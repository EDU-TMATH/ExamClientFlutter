import 'package:dio/dio.dart';
import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/features/auth/data/api/auth_api.dart';
import 'package:exam_client_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:exam_client_flutter/features/auth/data/storage/token_storage.dart';
import 'package:exam_client_flutter/features/auth/services/token_service.dart';
import 'package:exam_client_flutter/main.dart';
import 'package:exam_client_flutter/widgets/app_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTokenService extends TokenService {
  _FakeTokenService() : super(authApi: AuthApi(Dio()), storage: TokenStorage());

  @override
  Future<String?> getValidAccessToken() async => null;
}

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository() : super(AuthApi(Dio()), _FakeTokenService());

  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('MyApp builds inside ProviderScope', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Collapsed sidebar item does not overflow', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenServiceProvider.overrideWith((ref) => _FakeTokenService()),
          authRepositoryProvider.overrideWith((ref) => _FakeAuthRepository()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 120,
              height: 420,
              child: AppSidebar(activeRoute: '/'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.home), findsOneWidget);
  });
}
