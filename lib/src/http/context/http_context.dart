import 'package:nitro/src/http/context/params.dart';
import 'package:nitro/src/http/context/request.dart';
import 'package:nitro/src/http/context/response.dart';

class HttpContext {
  late final Request request;
  late final Response response;
  late final Params params;

  HttpContext();
}
