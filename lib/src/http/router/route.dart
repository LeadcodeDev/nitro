import 'dart:async';

import 'package:nitro/src/http/context/http_context.dart';
import 'package:nitro/src/http/router/http_method.dart';

typedef RouteHandler<T extends HttpContext> = FutureOr<dynamic> Function(T);

final class InternalRoute<T extends HttpContext> {
  final String path;
  final HttpMethod method;
  final RouteHandler<T> handler;

  InternalRoute(this.path, this.method, this.handler);
}
