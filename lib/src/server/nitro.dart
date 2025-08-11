import 'package:nitro/src/server/contracts/server.dart';

final class Nitro {
  final List<NitroServer> _providers = [];

  Nitro provide(NitroServer server) {
    _providers.add(server);
    return this;
  }

  Future<void> run() async {
    for (final server in _providers) {
      await server.run();
    }
  }
}

final nitro = Nitro();
