import 'package:flutter_test/flutter_test.dart';

import 'local_storage_test.mocks.dart';

void main() {
  // Set up mock client and local storage
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
  });

  // Initialize the local storage with some values
  setUp(() {
    mockLocalStorage.setItem('fullName', 'Test User');
    mockLocalStorage.setItem('bio', 'Test bio');
    mockLocalStorage.setItem('email', 'test@example.com');
    mockLocalStorage.setItem('phone', '1234567890');
    mockLocalStorage.setItem('website', 'https://test.com');
    mockLocalStorage.setItem('location', 'Test Location');
  });

  // testWidgets('UserProfile widget test', (tester) async {
  //   // Mocking LifeListProvider
  //   final mockLifeListProvider = MockLifeListProvider();
  //   when(mockLifeListProvider.fetchLifeList()).thenAnswer((_) async => []);
  //   when(db.getNumberOfBirdsInProvinces(mockClient))
  //       .thenAnswer((_) async => []);

  //   // Create the UserProfile widget
  //   await tester.pumpWidget(
  //     const MaterialApp(
  //       home: Scaffold(
  //         body: UserProfile(),
  //       ),
  //     ),
  //   );

  //   // Allow time for asynchronous operations to complete
  //   await tester.pumpAndSettle();

  //   // Check initial rendering
  //   expect(find.byType(SingleChildScrollView),
  //       findsOneWidget); // Updated to check for SingleChildScrollView
  //   expect(find.byType(CircleAvatar), findsOneWidget);
  //   expect(find.text('Test User'), findsOneWidget);
  //   expect(find.text('Test bio'), findsOneWidget);
  //   expect(find.text('test@example.com'), findsOneWidget);
  //   expect(find.text('1234567890'), findsOneWidget);
  //   expect(find.text('Test Location'), findsOneWidget);

  //   // Check switch interaction
  //   final switchFinder = find.byType(Switch);
  //   expect(switchFinder, findsOneWidget);
  //   await tester.tap(switchFinder);
  //   await tester.pump(); // Rebuild the widget with the new state

  //   // Check if the switch state changed
  //   expect(find.byType(Switch), findsOneWidget);

  //   // Check the button press
  //   final homeButtonFinder = find.text('Home');
  //   expect(homeButtonFinder, findsOneWidget);
  //   await tester.tap(homeButtonFinder);
  //   await tester.pumpAndSettle(); // Wait for navigation

  //   // Validate the navigation (if necessary)
  //   // Use a mock navigator or verify the context change as per your setup
  // });
}
