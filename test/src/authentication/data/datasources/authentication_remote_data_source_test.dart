import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImpl(client);
    registerFallbackValue(Uri.https(kBaseUrl));
  });

  group("createUser", () {
    test(
      "should complete successfully when the status code is 200 or 201",
      () async {
        // arrange
        when(
          () => client.post(
            any(),
            body: any(named: 'body'),
            headers: {'Content-Type': "application/json"},
          ),
        ).thenAnswer((_) async => http.Response("", 201));

        // act + assert
        expect(
          remoteDataSource.createUser(
            name: "name",
            createdAt: "createdAt",
            avatar: "avatar",
          ),
          completes,
        );

        verify(
          () => client.post(
            Uri.https(kBaseUrl, kCreateUserEndpoint),
            body: jsonEncode({
              "createdAt": "createdAt",
              "name": "name",
              "avatar": "avatar",
            }),
            headers: {'Content-Type': "application/json"},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test("should throw [APIException] when the status code is 200 or 201",
        () async {
      // arrange
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
          headers: {'Content-Type': "application/json"},
        ),
      ).thenAnswer((_) async => http.Response("Invalid email address", 400));

      // act + assert
      expect(
        remoteDataSource.createUser(
          name: "name",
          createdAt: "createdAt",
          avatar: "avatar",
        ),
        throwsA(
          const APIException(
            message: "Invalid email address",
            statusCode: 400,
          ),
        ),
      );
      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          body: jsonEncode({
            "createdAt": "createdAt",
            "name": "name",
            "avatar": "avatar",
          }),
          headers: {'Content-Type': "application/json"},
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
  });

  group("getUsers", () {
    const tUsers = [UserModel.empty()];

    test(
      "should return [List<User>] when the status code is 200",
      () async {
        // arrange
        when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
        );

        final result = await remoteDataSource.getUsers();

        // act + assert
        expect(result, equals(tUsers));

        verify(
          () => client.get(Uri.https(kBaseUrl, kGetUsersEndpoint)),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test("should throw [APIException] when the status code is 200", () async {
      // arrange
      when(
        () => client.get(any()),
      ).thenAnswer((_) async => http.Response(
          "Server down, Server down, I repeat Server down.", 500));

      // act + assert
      expect(
        remoteDataSource.getUsers(),
        throwsA(
          const APIException(
            message: "Server down, Server down, I repeat Server down.",
            statusCode: 500,
          ),
        ),
      );

      verify(
        () => client.get(Uri.https(kBaseUrl, kCreateUserEndpoint)),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
  });
}
