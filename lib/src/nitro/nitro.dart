import 'package:nitro/src/nitro/contracts/nitro_config.dart';
import 'package:nitro/src/nitro/contracts/server.dart';

final class Nitro {
  final List<NitroServer> _providers = [];

  Nitro provide(NitroServer server) {
    _providers.add(server);
    return this;
  }

  T Function() configure<T extends NitroConfig>(T Function() config) {
    return config;
  }

  Future<void> run() async {
    for (final server in _providers) {
      await server.run();
    }
  }
}

final nitro = Nitro();
