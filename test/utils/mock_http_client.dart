import 'dart:async';
import 'dart:io';

import 'package:mockito/mockito.dart';

class MockHttpClientResponse extends Mock implements HttpClientResponse {
  final _stream = readFile();

  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => File('test/res/map.png').lengthSync();

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  static Stream<List<int>> readFile() => File('test/res/map.png').openRead();
}

class MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() => Future.value(MockHttpClientResponse());
}

class MockClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) =>
      Future.value(MockHttpClientRequest());
}

class MockHttpOverrides extends Mock implements HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => MockClient();
}
