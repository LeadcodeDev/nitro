import 'dart:collection';

import 'package:nitro/src/http/context/http_context.dart';
import 'package:nitro/src/http/router/http_method.dart';
import 'package:nitro/src/http/router/route.dart';
import 'package:shelf/shelf.dart' as shelf;

final class HttpRouter<T extends HttpContext> {
  final List<InternalRoute<T>> _routes = [];
  final shelf.Pipeline Function(shelf.Pipeline) _applyMiddlewares;

  HttpRouter(this._applyMiddlewares);

  UnmodifiableListView<InternalRoute<T>> get dump =>
      UnmodifiableListView(_routes);

  void get(String path, RouteHandler<T> handler) {
    _routes.add(
      InternalRoute<T>(path, HttpMethod.get, handler, _applyMiddlewares),
    );
  }
  
  void typedGet(String path, RouteHandler<T> handler) {
    _routes.add(
      InternalRoute<T>(path, HttpMethod.get, handler, _applyMiddlewares),
    );
  }

  void post(String path, RouteHandler<T> handler) {
    _routes.add(
      InternalRoute<T>(path, HttpMethod.post, handler, _applyMiddlewares),
    );
  }
}
