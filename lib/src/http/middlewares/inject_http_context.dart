import 'package:nitro/src/http/context/http_context.dart';
import 'package:nitro/src/http/router/router.dart';
import 'package:nitro/src/http/utils.dart';
import 'package:shelf/shelf.dart' as shelf;

shelf.Middleware withNitroContext<T extends HttpContext>(
  T Function() factory,
  HttpRouter router,
) {
  return (shelf.Handler innerHandler) {
    return (shelf.Request request) {
      final ctx = createContext<T>(factory, request);
      final updatedRequest = request.change(
        context: {nitroContextKey: ctx, nitroRouterKey: router},
      );

      return innerHandler(updatedRequest);
    };
  };
}
