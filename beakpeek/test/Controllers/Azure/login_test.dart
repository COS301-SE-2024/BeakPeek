//import 'package:beakpeek/Controller/Azure/login.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
//import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
//import 'package:go_router/go_router.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/Model/UserProfile/achievment_list.dart';

//import 'login_test.mocks.dart';

// Create mock classes for dependencies
@GenerateMocks([LocalStorage, BuildContext, UserModel, AchievementList])
void main() {
  // late MockLocalStorage mockLocalStorage;
  // late MockBuildContext mockContext;
  // late MockUserModel mockUser;
  // late MockAchievementList mockAchievementList;

  // setUp(() {
  //   mockLocalStorage = MockLocalStorage();
  //   mockContext = MockBuildContext();
  //   mockUser = MockUserModel();
  //   mockAchievementList = MockAchievementList();
  // });

  // test('should navigate to home when accessToken exists in localStorage',
  //     () async {
  //   // Arrange: Mock the condition where accessToken already exists
  //   when(mockLocalStorage.getItem('accessToken')).thenReturn('dummy_token');

  //   // Act
  //   loginFunction(mockContext);

  //   // Assert: Ensure navigation to '/home' is called
  //   verify(mockContext.go('/home')).called(1);
  // });

  // test('should authenticate and store token, then navigate to home', () async
  // {
  //   when(mockLocalStorage.getItem('accessToken')).thenReturn(null);
  //   when(FlutterWebAuth2.authenticate(
  //     url:
  //         'https://beakpeekuserapi.azurewebsites.net/Identity/Account/Login?ReturnUrl=%2FHome%2FMobile', // Pass a valid dummy URL
  //     callbackUrlScheme: 'beakpeek',
  //   )).thenAnswer((_) async => 'beakpeek://callback?token=dummy_token');

  //   when(mockLocalStorage.setItem('accessToken', 'dummy_token'))
  //       .thenAnswer((_) async {});

  //   // Act: Call the login function
  //   loginFunction(mockContext);

  //   // Assert: Verify token was saved and navigation happened
  //   verify(mockLocalStorage.setItem('accessToken', 'dummy_token')).called(1);
  //   verify(mockContext.go('/home')).called(1);
  // });

  // test('should navigate to "/" when token is null', () async {
  //   // Arrange: Mock the scenario where no token is returned from auth
  //   when(mockLocalStorage.getItem('accessToken')).thenReturn(null);
  //   when(FlutterWebAuth2.authenticate(
  //     url:
  //         'https://beakpeekuserapi.azurewebsites.net/Identity/Account/Login?ReturnUrl=%2FHome%2FMobile', // Pass a valid dummy URL
  //     callbackUrlScheme: 'beakpeek',
  //   )).thenAnswer((_) async => 'beakpeek://callback');

  //   // Act
  //   loginFunction(mockContext);

  //   // Assert: Ensure the user is redirected to '/'
  //   verify(mockContext.go('/')).called(1);
  // });
}
