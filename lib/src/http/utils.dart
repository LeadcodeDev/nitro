import 'dart:convert';

import 'package:nitro/http.dart';
import 'package:shelf/shelf.dart' as shelf;

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
  return switch (response) {
    Response response => shelf.Response(
      response.statusCode,
      headers: response.headers,
      body: serializeResponse(response.body),
    ),
    _ => shelf.Response.ok(serializeResponse(response)),
  };
}

HttpContext createContext<T extends HttpContext>(
  T Function() factory,
  request,
) {
  final response = Response()..headers.addAll(request.headers);

  return factory()
    ..request = Request.wrap(request)
    ..response = response;
}
