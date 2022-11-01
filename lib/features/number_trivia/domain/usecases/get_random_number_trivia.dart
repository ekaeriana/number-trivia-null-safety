import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams>{
  final NumberTriviaRepository numberTriviaRepository;

  GetRandomNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>?> call(NoParams param) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}