import 'dart:convert';

import 'package:nitro/http.dart';
import 'package:nitro/src/http/context/params.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

const nitroContextKey = 'nitro.ctx';
const nitroRouterKey = 'nitro.router';

String serializeResponse(dynamic payload) {
  return switch (payload) {
    Map payload => json.encode(payload),
    List payload => json.encode(payload),
    _ => payload.toString(),
  };
}

shelf.Response wrapResponse(Response? response) {
  if (response case Response response) {
    if (response.body is Map || response.body is List) {
      response.headers.addAll({'Content-Type': 'application/json'});
    }
  }

  return switch (response) {
    Response response => shelf.Response(
      response.statusCode,
      headers: response.headers,
      body: serializeResponse(response.body),
    ),
    _ => shelf.Response.ok(serializeResponse(response)),
  };
}

Future<HttpContext> createContext<T extends HttpContext>(
  T Function() factory,
  shelf.Request request,
) async {
  final response = Response()..headers.addAll(request.headers);

  return factory()
    ..request = await Request.wrap(request)
    ..response = response
    ..params = Params(request.params);
}
