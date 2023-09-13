import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImpl authRepoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    authRepoImpl = AuthenticationRepositoryImpl(remoteDataSource);
  });

  const tException = APIException(
    message: "Unknown Error Occurred",
    statusCode: 500,
  );

  group("createUser", () {
    test(
      "should call the [RemoteDataSource.createUser] and complete successfully when the call is successful",
      () async {
        // arrange
        when(
          () => remoteDataSource.createUser(
            name: any(named: 'name'),
            createdAt: any(named: 'createdAt'),
            avatar: any(named: 'avatar'),
          ),
        ).thenAnswer((_) async => const Right(null));

        const createdAt = '_empty.createdAt';
        const name = '_empty.name';
        const avatar = '_empty.avatar';

        // act
        final result = await authRepoImpl.createUser(
          name: name,
          createdAt: createdAt,
          avatar: avatar,
        );

        // assert
        expect(result, equals(const Right(null)));
        verify(
          () => remoteDataSource.createUser(
            name: name,
            createdAt: createdAt,
            avatar: avatar,
          ),
        ).called(1);
      },
    );

    test(
      "should return a [APIFailure] when the call to the remote source is unsuccessful",
      () async {
        // arrange

        when(
          () => remoteDataSource.createUser(
            name: any(named: 'name'),
            createdAt: any(named: 'createdAt'),
            avatar: any(named: 'avatar'),
          ),
        ).thenThrow(tException);

        const createdAt = '_empty.createdAt';
        const name = '_empty.name';
        const avatar = '_empty.avatar';

        // act
        final result = await authRepoImpl.createUser(
          name: name,
          createdAt: createdAt,
          avatar: avatar,
        );

        expect(
          result,
          equals(Left(
            APIFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          )),
        );
        verify(
          () => remoteDataSource.createUser(
            name: name,
            createdAt: createdAt,
            avatar: avatar,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group("getUsers", () {
    test(
      "should call the [RemoteDataSource.getUsers] and return [List<User>] when call is successful.",
      () async {
        // arrange
        when(
          () => remoteDataSource.getUsers(),
        ).thenAnswer((_) async => []);

        // act
        final result = await authRepoImpl.getUsers();

        // assert
        expect(result, isA<Right<dynamic, List<User>>>());
        verify(
          () => remoteDataSource.getUsers(),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      "should return a [APIFailure] when the call to the remote source is unsuccessful",
      () async {
        when(
          () => remoteDataSource.getUsers(),
        ).thenThrow(tException);

        final result = await authRepoImpl.getUsers();

        expect(result, equals(Left(APIFailure.fromException(tException))));

        verify(
          () => remoteDataSource.getUsers(),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
