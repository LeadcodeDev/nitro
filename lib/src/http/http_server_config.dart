import 'package:nitro/src/nitro/contracts/nitro_config.dart';

final class HttpConfig implements NitroConfig {
  final String host;
  final int port;

  HttpConfig({required this.host, required this.port});

  factory HttpConfig.defaultConfig() {
    return HttpConfig(host: 'localhost', port: 3333);
  }
}
