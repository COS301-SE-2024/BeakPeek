// Mocks generated by Mockito 5.4.4 from annotations
// in beakpeek/test/UserProfile/local_storage_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:localstorage/localstorage.dart' as _i2;
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

class _FakeLocalStorage_0 extends _i1.SmartFake implements _i2.LocalStorage {
  _FakeLocalStorage_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [LocalStorageWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorageWrapper extends _i1.Mock implements _i2.LocalStorage {
  MockLocalStorageWrapper() {
    _i1.throwOnMissingStub(this);
  }

  _i2.LocalStorage get localStorage => (super.noSuchMethod(
        Invocation.getter(#localStorage),
        returnValue: _FakeLocalStorage_0(
          this,
          Invocation.getter(#localStorage),
        ),
      ) as _i2.LocalStorage);

  @override
  String? getItem(String? key) => (super.noSuchMethod(Invocation.method(
        #getItem,
        [key],
      )) as String?);

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

  _i4.Future<void> ready() => (super.noSuchMethod(
        Invocation.method(
          #ready,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}