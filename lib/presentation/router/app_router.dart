import 'package:flutter/material.dart';
import '../screens/auth/loginpage.dart';
import '../screens/auth/roleselection.dart';
import '../screens/auth/signuppage.dart';
import '../screens/home/admin_home_screen.dart';
import '../screens/home/homescreen.dart';
import '../screens/student/upcoming_events_page.dart';

class AppRouter {
  static const String roleSelection = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String upcomingEvents = '/upcoming-events';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionPage());
      case login:
        final args = settings.arguments as Map<String, dynamic>?;
        final role = args?['role'] as String? ?? 'student';
        return MaterialPageRoute(builder: (_) => LoginPage(userRole: role));
      case signup:
        final args = settings.arguments as Map<String, dynamic>?;
        final role = args?['role'] as String? ?? 'student';
        return MaterialPageRoute(builder: (_) => SignupPage(userRole: role));
      case home:
        final args = settings.arguments as Map<String, dynamic>?;
        final role = args?['role'] as String? ?? 'student';
        return MaterialPageRoute(
          builder: (_) => role == 'admin'
              ? const AdminHomeScreen() // You'll need to create this
              : const StudentHomeScreen(),
        );
      case upcomingEvents:
        return MaterialPageRoute(builder: (_) => const UpcomingEventsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  // Navigation helpers
  static void navigateToRoleSelection(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(roleSelection, (route) => false);
  }

  static void navigateToLogin(BuildContext context, String role) {
    Navigator.of(context).pushNamed(login, arguments: {'role': role});
  }

  static void navigateToSignup(BuildContext context, String role) {
    Navigator.of(context).pushNamed(signup, arguments: {'role': role});
  }

  static void navigateToHome(BuildContext context, String role) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      home,
      (route) => false,
      arguments: {'role': role},
    );
  }

  static void navigateToUpcomingEvents(BuildContext context) {
    Navigator.of(context).pushNamed(upcomingEvents);
  }
}
