import 'package:baulog/screens/appointments/appointments_page.dart';
import 'package:baulog/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:baulog/layout/base.dart';
import 'package:baulog/screens/about/about.dart';
import 'package:baulog/screens/introduction/introduction.dart';
import 'package:baulog/screens/news/news.dart';
import 'package:baulog/screens/splash/splash.dart';
import 'package:baulog/screens/webview/webViewScreen.dart';
import '../../core/services/service_base.dart';
import 'package:baulog/screens/login/login_page.dart';
/// [Routes] which contains common routing configuaration needed for the Application.
/// This includes all pages and all routes mapped to each other.
/// This also includes Routing table and Route for Unhandled routes.
/// Use [Routes] in MaterialApp:
///  ```dart
///  MaterialApp(
///    title: 'Flutter_App',
///    routes: Routes.buildRoutes,
///    initialRoute: Routes.login,
///    onUnknownRoute: Routes.unknownRoute,
///  );
///  ```

class Routes {
  Routes._();
  // routes
  static const splashScreen = '/splash-screen';
  static const login = '/login';
  static const introScreen = '/intro-screen';
  static const news = '/news';
  static const webViewScreen = '/webview';
  static const about = '/about';
  static const appointments = '/appointments';

  /// Routing Table needed for the App.
  static Map<String, WidgetBuilder> get buildRoutes {
    return {
      splashScreen: (BuildContext context) =>
          BaseLayout(page: SplashScreen(), isAppBar: false),
      introScreen: (BuildContext context) =>
          BaseLayout(page: IntroductionScreen(), isAppBar: false),
      news: (BuildContext context) =>
          BaseLayout(page: News(), isAppBar: true, text: 'News'),
      webViewScreen: (BuildContext context) =>
          BaseLayout(page: WebViewScreen(), isAppBar: false),
      about: (BuildContext context) =>
          BaseLayout(page: AboutScreen(), isAppBar: true),
    };
  }

  /// Handler for Error and Unhandled pages.
  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (ctx) {
        return LoginPage(); // LoginPage does not need the database parameter
      },
    );
  }

  /// Configures the initial route.
  static String get initialRoute {
    return Routes.login;
  }
}
