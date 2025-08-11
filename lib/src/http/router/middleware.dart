import 'dart:async';
import 'package:nitro/src/http/context/http_context.dart';

typedef MiddlewareHandler = FutureOr Function(HttpContext);

abstract interface class Middleware<T extends HttpContext> {
  FutureOr handle(T context);
}
