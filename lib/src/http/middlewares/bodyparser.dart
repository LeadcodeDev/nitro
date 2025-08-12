import 'dart:convert';
import 'package:nitro/http.dart';
import 'package:nitro/src/http/utils.dart';
import 'package:shelf/shelf.dart' as shelf;

shelf.Middleware bodyparser<T extends HttpContext?>({bool emptyAsNull = true}) {
  return (shelf.Handler innerHandler) {
    return (shelf.Request request) async {
      final ctx = request.context[nitroContextKey] as T;
      final body = ctx!.request.bodyString;

      try {
        ctx.request.body = Map<String, dynamic>.from(json.decode(body));
        return innerHandler(request);
      } catch (_) {}

      ctx.request.body = body;
      return innerHandler(request);
    };
  };
}
