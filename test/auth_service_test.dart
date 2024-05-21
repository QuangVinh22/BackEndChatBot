import 'package:chatbot/Models/usermodels.dart';
import 'package:chatbot/Service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'auth_service_test.mocks.dart'; // Đảm bảo rằng file này được import đúng

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient; // Sử dụng `late` để khai báo biến trễ
  late AuthServiceApi authService;

  setUp(() {
    mockClient = MockClient();
    authService = AuthServiceApi(
        client: mockClient); // Đúng cách inject client vào AuthServiceApi
  });

  group('AuthServiceApi', () {
    // Test case cho việc đăng ký thành công
    test('returns a User if the http call completes successfully', () async {
      when(mockClient.post(
        Uri.parse('https://backendchatbot-7keg.onrender.com/v1/Auth/register'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
          '{"data": {"id": "123", "name": "John Doe", "email": "john@example.com"}}',
          200));

      expect(
          await authService.registerService("john@example.com", "password123"),
          isA<User>());
    });

    // Test case cho việc đăng ký thất bại do tài nguyên không tồn tại
    test('throws NotFoundException when resource not found', () {
      when(mockClient.post(
        Uri.parse('https://backendchatbot-7keg.onrender.com/v1/Auth/register'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(authService.registerService("john@example.com", "password123"),
          throwsA(isA<NotFoundException>()));
    });

    // Test case cho việc đăng ký thất bại do email đã tồn tại
    test('throws UserAlreadyExistsException when email already exists', () {
      when(mockClient.post(
        Uri.parse('https://backendchatbot-7keg.onrender.com/v1/Auth/register'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Email đã tồn tại.', 500));

      expect(authService.registerService("john@example.com", "password123"),
          throwsA(isA<UserAlreadyExistsException>()));
    });
  });
}
  