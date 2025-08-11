import 'package:nitro/http.dart';
import 'package:nitro/src/http/utils.dart';
import 'package:shelf/shelf.dart' as shelf;

shelf.Middleware wrapMiddleware<T extends HttpContext>(
  MiddlewareHandler handle,
) {
  return (shelf.Handler innerHandler) {
    return (shelf.Request request) async {
      final ctx = request.context[nitroContextKey] as T;
      final result = await handle(ctx);

      if (result != null) {
        if (result is! Response) {
          ctx.response.body = result;
        }

        ctx.response.isComplete = true;
      }

      if (ctx.response.isComplete) {
        return wrapResponse(ctx.response);
      }

      return innerHandler(request);
    };
  };
}
