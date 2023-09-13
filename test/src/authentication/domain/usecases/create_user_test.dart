import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';

import 'authentication_repository.mock.dart';

void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthRepo();
    usecase = CreateUser(repository);
  });

  const params = CreateUserParams.empty();
  test(
    "should call the [AuthenticationRepository.createUser]",
    () async {
      // Arrange
      when(
        () => repository.createUser(
          name: any(named: 'name'),
          createdAt: any(named: 'createdAt'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repository.createUser(
          name: params.name,
          createdAt: params.createdAt,
          avatar: params.avatar,
        ),
      ).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
