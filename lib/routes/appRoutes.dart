import 'package:get/get.dart';
import 'authRoutes.dart';
import 'dashboardRoutes.dart';
import '../pages/auth/getStartedPage.dart';
import '../pages/dashboard/dashboard.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: AuthRoutes.getStarted, page: () => const GetStartedPage()),
    GetPage(name: DashboardRoutes.main, page: () => const Dashboard()),
  ];
}
