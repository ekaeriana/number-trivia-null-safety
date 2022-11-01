import 'package:number_trivia_app/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignInteger', () {
    test('should return integer when the string represents an unsign integer',
        () async {
      const str = '123';

      final result = inputConverter.stringToUnsignInteger(str);

      expect(result, const Right(123));
    });

    test('should return failure when the string is not integer', () async {
      const str = 'abc';

      final result = inputConverter.stringToUnsignInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should return failure when the string is negative integer', () async {
      const str = '-123';

      final result = inputConverter.stringToUnsignInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
