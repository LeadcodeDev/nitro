import 'package:nitro/http.dart';
import 'package:nitro/nitro.dart';
import 'package:nitro/src/http/middlewares/bodyparser.dart';
import 'package:nitro/src/http/middlewares/inject_http_context.dart';
import 'package:nitro/src/http/middlewares/wrap_middleware.dart';
import 'package:nitro/src/http/utils.dart';
import 'package:nitro/src/nitro/contracts/server.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vine/vine.dart';

extension HttpNitro on Nitro {
  NitroHttpServer
  createHttpServer<T extends HttpContext, M extends Middleware>({
    required dynamic Function(HttpRouter<T>) router,
    T Function()? context,
    List<M Function()> middlewares = const [],
    HttpConfig Function()? config,
  }) {
    return NitroHttpServer<T, M>(
      factoryContext: context,
      router: router,
      middlewares: middlewares.map((middleware) => middleware()).toList(),
      config: config,
    );
  }
}

final class NitroHttpServer<T extends HttpContext, M extends Middleware>
    implements NitroServer {
  final T Function()? _factoryContext;
  final void Function(HttpRouter<T>) _router;
  final List<M> _middlewares;
  final HttpConfig Function()? _config;

  NitroHttpServer({
    required Function(HttpRouter<T>) router,
    T Function()? factoryContext,
    List<M> middlewares = const [],
    HttpConfig Function()? config,
  }) : _router = router,
       _middlewares = middlewares,
       _factoryContext = factoryContext,
       _config = config;

  @override
  Future<void> run() async {
    env.defineOf(HttpEnv.new);

    final config = (_config != null ? _config() : HttpConfig.defaultConfig());

    final ctxFactory = _factoryContext ?? HttpContext.new;
    shelf.Pipeline applyMiddlewares(shelf.Pipeline pipeline) {
      shelf.Pipeline pip = pipeline
          .addMiddleware(shelf.logRequests())
          .addMiddleware(withNitroContext(ctxFactory))
          .addMiddleware(bodyparser());

      for (final middleware in _middlewares) {
        pip = pipeline.addMiddleware(
          (request) => wrapMiddleware(middleware.handle)(request),
        );
      }

      return pip;
    }

    final router = Router();
    final nitroHttpRouter = HttpRouter<T>(applyMiddlewares);
    _router(nitroHttpRouter);

    for (final route in nitroHttpRouter.dump) {
      route.wrapIntoShelfRoute(router, (request, handler) async {
        final ctx = request.context[nitroContextKey] as T;
        try {
          final result = await handler(ctx);

          if (result != null && result is! Response) {
            ctx.response.body = result;
            ctx.response.isComplete = true;
          }
        } on VineValidationException catch (error) {
          ctx.response.badRequest(body: error.message);
        }

        return wrapResponse(ctx.response);
      });
    }

    await serve(router.call, config.host, config.port, shared: true);
  }
}
