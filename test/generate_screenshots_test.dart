import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_toolbox/core/constants/app_constants.dart';
import 'package:home_toolbox/core/theme/app_theme.dart';
import 'package:home_toolbox/screens/auth/login_screen.dart';
import 'package:home_toolbox/screens/auth/register_screen.dart';
import 'package:home_toolbox/screens/auth/forgot_password_screen.dart';
import 'package:home_toolbox/screens/profile/profile_screen.dart';
import 'package:home_toolbox/screens/profile/change_password_screen.dart';
import 'package:home_toolbox/screens/home/home_dashboard_screen.dart';
import 'package:home_toolbox/screens/tools/tools_list_screen.dart';
import 'package:home_toolbox/screens/tools/tool_detail_screen.dart';

void main() {
  final outDir = Directory(r'D:\Навчальні архіви\3курс\1sem\КП\Лабораторна3\screenshots');
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  setUpAll(() async {
    final regularFont = File(r'C:\Windows\Fonts\segoeui.ttf');
    final boldFont = File(r'C:\Windows\Fonts\segoeuib.ttf');

    if (regularFont.existsSync()) {
      final regBytes = regularFont.readAsBytesSync();
      final boldBytes = boldFont.existsSync() ? boldFont.readAsBytesSync() : regBytes;

      for (final family in ['Roboto', 'sans-serif', 'Segoe UI', '.SF Pro Text']) {
        final loader = FontLoader(family)
          ..addFont(Future.value(ByteData.view(regBytes.buffer)))
          ..addFont(Future.value(ByteData.view(boldBytes.buffer)));
        await loader.load();
      }
    }

    final iconFile = File(r'D:\flutter_sdk\flutter\bin\cache\artifacts\material_fonts\MaterialIcons-Regular.otf');
    if (iconFile.existsSync()) {
      final iconBytes = iconFile.readAsBytesSync();
      final iconLoader = FontLoader('MaterialIcons')
        ..addFont(Future.value(ByteData.view(iconBytes.buffer)));
      await iconLoader.load();
    }
  });

  Future<void> captureScreen({
    required WidgetTester tester,
    required Widget screen,
    required String fileName,
  }) async {
    tester.view.physicalSize = const Size(412, 892);
    tester.view.devicePixelRatio = 1.0;

    final boundaryKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: RepaintBoundary(
          key: boundaryKey,
          child: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      final boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final file = File('${outDir.path}/$fileName');
      await file.writeAsBytes(buffer);
    });
  }

  testWidgets('Capture screenshots of all screens', (WidgetTester tester) async {
    // S-01: Login
    await captureScreen(
      tester: tester,
      screen: const LoginScreen(),
      fileName: 's01_login.png',
    );

    // S-02: Register
    await captureScreen(
      tester: tester,
      screen: const RegisterScreen(),
      fileName: 's02_register.png',
    );

    // S-03: Forgot Password
    await captureScreen(
      tester: tester,
      screen: const ForgotPasswordScreen(),
      fileName: 's03_forgot_password.png',
    );

    // S-04: Change Password
    await captureScreen(
      tester: tester,
      screen: const ChangePasswordScreen(),
      fileName: 's04_change_password.png',
    );

    // S-05: Home Dashboard
    await captureScreen(
      tester: tester,
      screen: const HomeDashboardScreen(),
      fileName: 's05_home_dashboard.png',
    );

    // S-07: Tools List
    await captureScreen(
      tester: tester,
      screen: const ToolsListScreen(),
      fileName: 's07_tools_list.png',
    );

    // S-09: Tool Detail
    await captureScreen(
      tester: tester,
      screen: ToolDetailScreen(tool: AppConstants.mockTools[1]),
      fileName: 's09_tool_detail.png',
    );

    // S-17: Profile
    await captureScreen(
      tester: tester,
      screen: const ProfileScreen(),
      fileName: 's17_profile.png',
    );
  });
}
