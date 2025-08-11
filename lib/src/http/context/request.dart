import 'package:shelf/shelf.dart' as shelf;

final class Request {
  final Map<String, String> headers;

  Request({required this.headers});

  factory Request.wrap(shelf.Request request) {
    return Request(headers: request.headers);
  }
}
