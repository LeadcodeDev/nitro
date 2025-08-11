enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE');

  final String value;

  const HttpMethod(this.value);

  factory HttpMethod.wrap(String value) {
    return HttpMethod.values.firstWhere((method) => method.value == value);
  }
}
