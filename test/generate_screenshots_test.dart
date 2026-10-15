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
import 'package:home_toolbox/screens/locations/storage_locations_screen.dart';
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
    Size size = const Size(412, 892),
  }) async {
    tester.view.physicalSize = size;
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
    // S-01: Login Mobile (image1.png)
    await captureScreen(
      tester: tester,
      screen: const LoginScreen(),
      fileName: 's01_login.png',
      size: const Size(412, 892),
    );

    // S-01-Wide: Login Widescreen Desktop / Web
    await captureScreen(
      tester: tester,
      screen: const LoginScreen(),
      fileName: 's01_login_widescreen.png',
      size: const Size(1100, 750),
    );

    // S-02: Register Mobile (image2.png)
    await captureScreen(
      tester: tester,
      screen: const RegisterScreen(),
      fileName: 's02_register.png',
      size: const Size(412, 892),
    );

    // S-03: Forgot Password Mobile (image3.png)
    await captureScreen(
      tester: tester,
      screen: const ForgotPasswordScreen(),
      fileName: 's03_forgot_password.png',
      size: const Size(412, 892),
    );

    // S-04: Change Password Mobile
    await captureScreen(
      tester: tester,
      screen: const ChangePasswordScreen(),
      fileName: 's04_change_password.png',
      size: const Size(412, 892),
    );

    // S-05: Home Dashboard Mobile (image5.png)
    await captureScreen(
      tester: tester,
      screen: const HomeDashboardScreen(),
      fileName: 's05_home_dashboard.png',
      size: const Size(412, 892),
    );

    // S-06: Home Dashboard Widescreen Desktop / Web
    await captureScreen(
      tester: tester,
      screen: const HomeDashboardScreen(),
      fileName: 's06_home_widescreen.png',
      size: const Size(1100, 750),
    );

    // S-07: Tools List Mobile (image6.png)
    await captureScreen(
      tester: tester,
      screen: const ToolsListScreen(),
      fileName: 's07_tools_list.png',
      size: const Size(412, 892),
    );

    // S-08: Tools Widescreen Desktop / Web (image12.png)
    await captureScreen(
      tester: tester,
      screen: const ToolsListScreen(),
      fileName: 's08_tools_widescreen.png',
      size: const Size(1100, 750),
    );

    // S-09: Tool Detail Mobile (image7.png)
    await captureScreen(
      tester: tester,
      screen: ToolDetailScreen(tool: AppConstants.mockTools[0]),
      fileName: 's09_tool_detail.png',
      size: const Size(412, 892),
    );

    // S-11: Locations Mobile (image11.png)
    await captureScreen(
      tester: tester,
      screen: const StorageLocationsScreen(),
      fileName: 's11_locations.png',
      size: const Size(412, 892),
    );

    // S-12: Locations Widescreen Desktop / Web
    await captureScreen(
      tester: tester,
      screen: const StorageLocationsScreen(),
      fileName: 's12_locations_widescreen.png',
      size: const Size(1100, 750),
    );

    // S-17: Profile Mobile (image4.png)
    await captureScreen(
      tester: tester,
      screen: const ProfileScreen(),
      fileName: 's17_profile.png',
      size: const Size(412, 892),
    );

    // S-18: Profile Widescreen Desktop / Web
    await captureScreen(
      tester: tester,
      screen: const ProfileScreen(),
      fileName: 's18_profile_widescreen.png',
      size: const Size(1100, 750),
    );
  });
}
