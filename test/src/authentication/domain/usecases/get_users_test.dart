import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

import 'authentication_repository.mock.dart';

void main() {
  late GetUsers usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthRepo();
    usecase = GetUsers(repository);
  });

  const tResponse = [User.empty()];

  test(
    "should call the [AuthenticationRepository.getUsers] and return [List<User>]",
    () async {
      // Arrange
      when(
        () => repository.getUsers(),
      ).thenAnswer((_) async => const Right(tResponse));

      // Act
      final result = await usecase();

      // Assert
      expect(result, equals(const Right<dynamic, List<User>>(tResponse)));
      verify(
        () => repository.getUsers(),
      ).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
