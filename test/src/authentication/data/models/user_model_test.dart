import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  // Arrange
  const tModel = UserModel.empty();

  test("should be a subclass of [User] entity", () {
    // Assert
    expect(tModel, isA<User>());
  });

  final tJson = fixture("user.json");
  final tMap = jsonDecode(tJson) as DataMap;

  group("fromMap", () {
    test("should return a [UserModel] with right data", () {
      // Act
      final result = UserModel.fromMap(tMap);
      // Assert
      expect(result, equals(tModel));
    });
  });

  group("fromJson", () {
    test("should return a [UserModel] with right data", () {
      // Act
      final result = UserModel.fromJson(tJson);
      // Assert
      expect(result, equals(tModel));
    });
  });

  group("toMap", () {
    test("should return a [Map] with right data", () {
      // Act
      final result = tModel.toMap();
      // Assert
      expect(result, equals(tMap));
    });
  });

  group("toJson", () {
    test("should return a [JSON] string with right data", () {
      // Act
      final result = tModel.toJson();
      // Assert
      expect(result, equals(tJson));
    });
  });

  group("copyWith", () {
    test("should return a [UserModel] with different data", () {
      // Act
      final result = tModel.copyWith(name: 'Paul');
      // Assert
      expect(result.name, equals("Paul"));
    });
  });
}
