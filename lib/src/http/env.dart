import 'package:env_guard/env_guard.dart';

final class HttpEnv implements DefineEnvironment {
  static final String host = 'HOST';
  static final String port = 'PORT';

  @override
  final Map<String, EnvSchema> schema = {
    host: env.string(),
    port: env.number().integer(),
  };
}
