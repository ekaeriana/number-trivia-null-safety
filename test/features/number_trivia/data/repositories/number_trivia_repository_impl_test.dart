import 'dart:math';

import 'package:number_trivia_app/core/error/exception.dart';
import 'package:number_trivia_app/core/error/failure.dart';
import 'package:number_trivia_app/core/network/network_info.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/number_trivia/data/repositories/number_trivia_prepository_impl.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'number_trivia_repository_impl_test.mocks.dart';


class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

@GenerateMocks([NetworkInfo])
// @GenerateMocks([NumberTriviaRemoteDataSource])
@GenerateMocks([
  NumberTriviaRemoteDataSource
], customMocks: [
  MockSpec<NumberTriviaRemoteDataSource>(
      as: #MockNumberTriviaRemoteDataSourceForTest,
      returnNullOnMissingStub: true),
])

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is Online', () {
      setUp(() {
        //assert
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is Offline', () {
      setUp(() {
        //assert
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test Text', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if device online', () async {
      // assert
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // expect
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data successfully',
          () async {
        //assert
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // expect
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache data locally when the call to remote data successfully',
          () async {
        //assert
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // expect
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data unsuccessfully',
          () async {
        //assert
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow((ServerException()));
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // expect
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    /// Run Offline
    runTestOffline(() {
      test('should return last cached trivia when the cache data present',
          () async {
        //assert
        when(mockLocalDataSource.getlastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // expect
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getlastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is not cached data',
          () async {
        //assert
        when(mockLocalDataSource.getlastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // expect
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getlastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(text: 'test Text', number: Random().nextInt(100));
    NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if device online', () async {
      // assert
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getRandomNumberTrivia();
      // expect
      verify(mockNetworkInfo.isConnected);
    });

    /// Run Online
    runTestOnline(() {
      test(
          'should return random trivia when the call to remote data successfully',
          () async {
        //assert
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // expect
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache data locally when the call to remote data successfully',
          () async {
        //assert
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getRandomNumberTrivia();
        // expect
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data unsuccessfully',
          () async {
        //assert
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow((ServerException()));
        // act
        final result = await repository.getRandomNumberTrivia();
        // expect
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    /// Run Offline
    runTestOffline(() {
      test('should return last cached trivia when the cache data present',
          () async {
        //assert
        when(mockLocalDataSource.getlastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // expect
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getlastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is not cached data',
          () async {
        //assert
        when(mockLocalDataSource.getlastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // expect
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getlastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
