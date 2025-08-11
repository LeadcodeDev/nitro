final class Response {
  int statusCode = 200;
  Map<String, String> headers = {};
  dynamic body;
  bool isComplete = false;

  Response ok({Map<String, String> headers = const {}, dynamic body}) {
    isComplete = true;
    statusCode = 200;
    this.headers.addAll(headers);
    this.body = body;

    return this;
  }

  Response notFound({Map<String, String> headers = const {}, dynamic body}) {
    isComplete = true;
    statusCode = 404;
    this.headers.addAll(headers);
    this.body = body;

    return this;
  }

  Response badRequest({Map<String, String> headers = const {}, dynamic body}) {
    isComplete = true;
    statusCode = 400;
    this.headers.addAll(headers);
    this.body = body;

    return this;
  }

  Response unauthorized({
    Map<String, String> headers = const {},
    dynamic body,
  }) {
    isComplete = true;
    statusCode = 401;
    this.headers.addAll(headers);
    this.body = body;

    return this;
  }

  Response forbidden({Map<String, String> headers = const {}, dynamic body}) {
    isComplete = true;
    statusCode = 403;
    this.headers.addAll(headers);
    this.body = body;

    return this;
  }

  Response internalError({
    Map<String, String> headers = const {},
    dynamic body,
  }) {
    isComplete = true;
    statusCode = 500;
    this.headers.addAll(headers);
    this.body = body;

    return this;
  }
}
