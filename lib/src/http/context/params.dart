import 'dart:collection';

final class Params {
  final Map<String, String> _params;
  UnmodifiableMapView<String, String> get dump => UnmodifiableMapView(_params);

  Params(this._params);
}
