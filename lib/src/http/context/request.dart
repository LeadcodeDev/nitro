import 'package:shelf/shelf.dart' as shelf;
import 'package:vine/vine.dart';

final class Request {
  final Map<String, String> headers;
  final String bodyString;
  dynamic body;

  Request({required this.headers, required this.bodyString, this.body});

  Map<String, dynamic> validateUsing(Validator validator) {
    return Map<String, dynamic>.from(validator.validate(body));
  }

  static Future<Request> wrap(shelf.Request request) async {
    return Request(
      headers: request.headers,
      bodyString: await request.readAsString(),
    );
  }
}
