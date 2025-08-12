import 'package:nitro/src/http/context/http_context.dart';
import 'package:nitro/src/http/utils.dart';
import 'package:shelf/shelf.dart' as shelf;

shelf.Middleware withNitroContext<T extends HttpContext>(T Function() factory) {
  return (shelf.Handler innerHandler) {
    return (shelf.Request request) async {
      final ctx = await createContext<T>(factory, request);
      final updatedRequest = request.change(context: {nitroContextKey: ctx});

      return innerHandler(updatedRequest);
    };
  };
}
