import 'dart:collection';

import 'package:nitro/src/http/context/http_context.dart';
import 'package:nitro/src/http/router/http_method.dart';
import 'package:nitro/src/http/router/route.dart';

final class HttpRouter<T extends HttpContext> {
  final List<InternalRoute<T>> _routes = [];
  UnmodifiableListView<InternalRoute<T>> get dump =>
      UnmodifiableListView(_routes);

  void get(String path, RouteHandler<T> handler) {
    _routes.add(InternalRoute<T>(path, HttpMethod.get, handler));
  }
}
