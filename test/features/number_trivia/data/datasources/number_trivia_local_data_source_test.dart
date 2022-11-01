import 'dart:convert';

import 'package:number_trivia_app/core/error/exception.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([
  SharedPreferences
], customMocks: [
  MockSpec<SharedPreferences>(
      as: #MockSharedPreferencesForTest, returnNullOnMissingStub: true),
])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixtures('trivia_cached.json')));

    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixtures('trivia_cached.json'));

      final result = await dataSource.getlastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw CacheException from when there is no cache value',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getlastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: 1);

    test('should call SharedPreferences to cache the data', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });

    test('should throw CacheException from when there is no cache value',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getlastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}
