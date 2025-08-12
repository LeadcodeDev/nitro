import 'dart:async';

import 'package:nitro/src/http/context/http_context.dart';
import 'package:nitro/src/http/router/http_method.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;

typedef RouteHandler<T extends HttpContext> = FutureOr Function(T);
typedef RouteHandlerCallback<T extends HttpContext> =
    FutureOr<shelf.Response> Function(shelf.Request, RouteHandler<T>);

final class InternalRoute<T extends HttpContext> {
  final String path;
  final HttpMethod method;
  final RouteHandler<T> handler;
  final shelf.Pipeline Function(shelf.Pipeline) applyMiddleware;

  InternalRoute(this.path, this.method, this.handler, this.applyMiddleware);

  void wrapIntoShelfRoute(Router router, RouteHandlerCallback<T> callback) {
    if (method == HttpMethod.get) {
      router.get(path, _createHandler(callback));
    } else if (method == HttpMethod.post) {
      router.post(path, _createHandler(callback));
    } else if (method == HttpMethod.put) {
      router.put(path, _createHandler(callback));
    } else if (method == HttpMethod.delete) {
      router.delete(path, _createHandler(callback));
    } else if (method == HttpMethod.patch) {
      router.patch(path, _createHandler(callback));
    } else if (method == HttpMethod.options) {
      router.options(path, _createHandler(callback));
    } else if (method == HttpMethod.head) {
      router.head(path, _createHandler(callback));
    }
  }

  shelf.Handler _createHandler(RouteHandlerCallback<T> callback) {
    final pip = applyMiddleware(const shelf.Pipeline());
    return pip.addHandler((request, [params]) async {
      final response = await callback(request, handler);
      return response;
    });
  }
}
