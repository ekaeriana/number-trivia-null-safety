import 'package:number_trivia_app/core/error/failure.dart';
import 'package:number_trivia_app/core/usecases/usecase.dart';
import 'package:number_trivia_app/core/util/input_converter.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia])
@GenerateMocks([GetRandomNumberTrivia])
@GenerateMocks([InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state should be empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignInteger(any))
          .thenReturn(const Right(tNumberParsed));
    }

    test(
      'should call the input converter to validate and conver the string to unsign integer',
      () async* {
        setUpMockInputConverterSuccess();

        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignInteger(any));

        verify(mockInputConverter.stringToUnsignInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input invalid',
      () async* {
        when(mockInputConverter.stringToUnsignInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        final expected = [
          Empty(),
          const Error(message: INVALID_INPUT_FAILURE_MESSAGE)
        ];
        expectLater(bloc, emitsInOrder(expected));

        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from concrete usecase',
      () async* {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));

        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));

        verify(
            mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten success',
      () async* {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Loaded(trivia: tNumberTrivia)
        ];
        expectLater(bloc, emitsInOrder(expected));

        //act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data failed',
      () async* {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc, emitsInOrder(expected));

        //act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the rror when getting data failed',
      () async* {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: CACHE_FAILURE_MESSAGE)
        ];
        expectLater(bloc, emitsInOrder(expected));

        //act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);

    test(
      'should get data from random usecase',
      () async* {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));

        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));

        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten success',
      () async* {
        //arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Loaded(trivia: tNumberTrivia)
        ];
        expectLater(bloc, emitsInOrder(expected));

        //act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data failed',
      () async* {
        //arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc, emitsInOrder(expected));

        //act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the rror when getting data failed',
      () async* {
        //arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: CACHE_FAILURE_MESSAGE)
        ];
        expectLater(bloc, emitsInOrder(expected));

        //act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
