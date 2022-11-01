import 'dart:convert';

import 'package:number_trivia_app/core/error/exception.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixtures_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

// class MockHttpClient extends Mock implements http.Client {}

@GenerateMocks([
  http.Client
], customMocks: [
  MockSpec<http.Client>(
      as: #MockHttpClientForTest, returnNullOnMissingStub: true),
])
void main() {
  late MockClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response(fixtures('trivia.json'), 200));
  }

  void setUpHttpClienFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response('Something went wrong', 200));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode('trivia.json'));

    test('''should perform GET request on URL with number
        being the endpoint and with application/json header''', () async {
      setUpHttpClientSuccess200();

      dataSource.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient
          .get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('should return number trivia when response code 200 (success)',
        () async {
      setUpHttpClientSuccess200();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when response code not 200', () async {
      setUpHttpClienFailure404();
      
      final call = dataSource.getConcreteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });


  group('getRandomNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode('trivia.json'));

    test('''should perform GET request on URL with number
        being the endpoint and with application/json header''', () async {
      setUpHttpClientSuccess200();

      dataSource.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient
          .get(Uri.parse('http://numbersapi.com/random'), headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('should return number trivia when response code 200 (success)',
        () async {
      setUpHttpClientSuccess200();

      final result = await dataSource.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when response code not 200', () async {
      setUpHttpClienFailure404();

      final call = dataSource.getRandomNumberTrivia;

      expect(
          () => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
