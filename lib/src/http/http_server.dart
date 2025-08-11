import 'package:nitro/http.dart';
import 'package:nitro/server.dart';
import 'package:nitro/src/http/middlewares/inject_http_context.dart';
import 'package:nitro/src/http/middlewares/wrap_middleware.dart';
import 'package:nitro/src/http/router/http_method.dart';
import 'package:nitro/src/http/router/route.dart';
import 'package:nitro/src/http/utils.dart';
import 'package:nitro/src/server/contracts/server.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart';

extension HttpNitro on Nitro {
  NitroHttpServer
  createHttpServer<T extends HttpContext, M extends Middleware>({
    required HttpRouter<T> router,
    T Function()? context,
    List<M Function()> middlewares = const [],
  }) {
    return NitroHttpServer<T, M>(
      factoryContext: context,
      router: router,
      middlewares: middlewares.map((middleware) => middleware()).toList(),
    );
  }
}

final class NitroHttpServer<T extends HttpContext, M extends Middleware>
    implements NitroServer {
  final T Function()? _factoryContext;
  final HttpRouter<T> _router;
  final List<M> _middlewares;

  NitroHttpServer({
    required HttpRouter<T> router,
    T Function()? factoryContext,
    List<M> middlewares = const [],
  }) : _router = router,
       _middlewares = middlewares,
       _factoryContext = factoryContext;

  @override
  Future<void> run() async {
    shelf.Pipeline pipeline = const shelf.Pipeline().addMiddleware(
      withNitroContext(_factoryContext ?? HttpContext.new, _router),
    );

    for (final middleware in _middlewares) {
      pipeline = pipeline.addMiddleware(
        (request) => wrapMiddleware(middleware.handle)(request),
      );
    }

    final handler = pipeline.addHandler((request) async {
      final handler = _router.dump.where(
        (route) => route.method == HttpMethod.wrap(request.method),
      );

      if (handler.firstOrNull case final InternalRoute<T> route) {
        final ctx = request.context[nitroContextKey] as T;
        final result = await route.handler(ctx);

        if (result != null) {
          if (result is! Response) {
            ctx.response.body = result;
          }

          ctx.response.isComplete = true;
        }

        return wrapResponse(ctx.response);
      }

      return shelf.Response.notFound('Route not found');
    });

    await serve(handler, 'localhost', 3333, shared: true);
  }
}
