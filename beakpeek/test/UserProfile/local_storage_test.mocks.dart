// Mocks generated by Mockito 5.4.4 from annotations
// in beakpeek/test/UserProfile/local_storage_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:localstorage/src/interface.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [LocalStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorage extends _i1.Mock implements _i2.LocalStorage {
  MockLocalStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get length => (super.noSuchMethod(
        Invocation.getter(#length),
        returnValue: 0,
      ) as int);

  @override
  String? key(int? index) => (super.noSuchMethod(Invocation.method(
        #key,
        [index],
      )) as String?);

  @override
  String? getItem(String? key) => (super.noSuchMethod(Invocation.method(
        #getItem,
        [key],
      )) as String?);

  @override
  void removeItem(String? key) => super.noSuchMethod(
        Invocation.method(
          #removeItem,
          [key],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setItem(
    String? key,
    String? value,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #setItem,
          [
            key,
            value,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void clear() => super.noSuchMethod(
        Invocation.method(
          #clear,
          [],
        ),
        returnValueForMissingStub: null,
      );
}