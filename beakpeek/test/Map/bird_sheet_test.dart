import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beakpeek/View/Map/bird_sheet.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../bird_sheet_test.mocks.dart';

List mockBirds = jsonDecode(
    '[{"id":173142,"pentad":{"pentad_Allocation":"2205_2930","pentad_Longitude":2205,"pentad_Latitude":2930,"province":{"id":5,"name":"limpopo","birds":null},"total_Cards":2},"bird":{"ref":54,"common_group":"Heron","common_species":"Grey","genus":"Ardea","species":"cinerea","full_Protocol_RR":27.3994,"full_Protocol_Number":91293,"latest_FP":"2024-07-31T00:00:00","image_Url":"https://beakpeekstorage.blob.core.windows.net/bird-images/54_Grey_Heron.jpg","info":"The grey heron is a long-legged wading bird of the heron family, Ardeidae, native throughout temperate Europe and Asia, and also parts of Africa. It is resident in much of its range, but some populations from the more northern parts migrate southwards in autumn. A bird of wetland areas, it can be seen around lakes, rivers, ponds, marshes and on the sea coast. It feeds mostly on aquatic creatures which it catches after standing stationary beside or in the water, or stalking its prey through the shallows.","provinces":null},"jan":null,"feb":null,"mar":0.0,"apr":null,"may":null,"jun":null,"jul":100.0,"aug":null,"sep":null,"oct":null,"nov":null,"dec":null,"total_Records":1,"reportingRate":50.0},{"id":173143,"pentad":{"pentad_Allocation":"2205_2930","pentad_Longitude":2205,"pentad_Latitude":2930,"province":{"id":5,"name":"limpopo","birds":null},"total_Cards":2},"bird":{"ref":59,"common_group":"Egret","common_species":"Little","genus":"Egretta","species":"garzetta","full_Protocol_RR":15.6873,"full_Protocol_Number":52269,"latest_FP":"2024-07-30T00:00:00","image_Url":"https://beakpeekstorage.blob.core.windows.net/bird-images/59_Little_Egret.jpg","info":"The little egret is a species of small heron in the family Ardeidae. It is a white bird with a slender black beak, long black legs and, in the western race, yellow feet. As an aquatic bird, it feeds in shallow water and on land, consuming a variety of small creatures. It breeds colonially, often with other species of water birds, making a platform nest of sticks in a tree, bush or reed bed. A clutch of three to five bluish-green eggs is laid and incubated by both parents for about three weeks. The young fledge at about six weeks of age.","provinces":null},"jan":null,"feb":null,"mar":0.0,"apr":null,"may":null,"jun":null,"jul":100.0,"aug":null,"sep":null,"oct":null,"nov":null,"dec":null,"total_Records":1,"reportingRate":50.0}]');

@GenerateMocks([http.Client])
void main() {
  // Create mock for http client
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
  });

  testWidgets('BirdSheet shows loading and displays birds correctly',
      (WidgetTester tester) async {
    // Set up mock to return mockBirds
    when(mockClient.get(Uri.parse(
            'https://beakpeekbirdapi.azurewebsites.net/api/Bird/pentad123/pentad')))
        .thenAnswer((_) async => http.Response(jsonEncode(mockBirds), 200));

    // Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BirdSheet(
            pentadId: 'pentad123',
            month: 'Year_Round',
            client: mockClient,
          ),
        ),
      ),
    );

    // Check if loading indicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for FutureBuilder to complete and render the bird list
    await tester.pumpAndSettle();

    expect(find.byType(BirdList), findsOneWidget);
  });

  testWidgets('BirdSheet filters birds correctly', (WidgetTester tester) async {
    // Set up mock to return mockBirds
    when(mockClient.get(Uri.parse(
            'https://beakpeekbirdapi.azurewebsites.net/api/Bird/pentad123/pentad')))
        .thenAnswer((_) async => http.Response(jsonEncode(mockBirds), 200));

    // Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BirdSheet(
              pentadId: 'pentad123', month: 'Year_Round', client: mockClient),
        ),
      ),
    );

    // Wait for FutureBuilder to complete
    await tester.pumpAndSettle();

    // Check initial state (both birds are visible)
    expect(find.text('Grey Heron'), findsAny);
    expect(find.text('Little Egret'), findsOneWidget);

    expect(find.byType(ListTile), findsAtLeastNWidgets(2));

    // Search for specific bird names within ListTiles
    final listTileFinder = find.byType(ListTile);

    // Search for 'Sparrow' text inside a ListTile
    expect(
      find.descendant(of: listTileFinder, matching: find.text('Grey Heron')),
      findsOneWidget,
    );

    // Search for 'Weaver' text inside a ListTile
    expect(
      find.descendant(of: listTileFinder, matching: find.text('Little Egret')),
      findsOneWidget,
    );

    // Open filter dropdown
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();

    // // Select 'Haven\'t Seen' filter option
    await tester.tap(find.text('Haven\'t Seen').last);
    await tester.pumpAndSettle();

    // Ensure filtered list updates accordingly
    expect(find.text('Grey Heron'), findsOneWidget);
    expect(find.text('Little Egret'), findsOneWidget);
  });
}
