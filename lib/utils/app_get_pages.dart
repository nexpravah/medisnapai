import 'package:medilens/features/home/history_page.dart';
import 'package:medilens/features/settings/pages/about_us_page.dart';

import '../common_imports.dart';
import '../features/home/details_page.dart';
import '../features/home/home_page.dart';
import '../features/settings/pages/privacy_policy_page.dart';
import '../features/settings/pages/settings_page.dart';
import '../features/settings/pages/terms_and_condition_page.dart';

class AppGetPages {
  static List<GetPage<dynamic>> list = [
    GetPage(name: AppPageRoute.home, page: () => HomePage()),
    GetPage(name: AppPageRoute.settings, page: () => SettingsPage()),
    GetPage(name: AppPageRoute.details, page: () => DetailsPage()),
    GetPage(name: AppPageRoute.history, page: () => HistoryPage()),
    GetPage(name: AppPageRoute.aboutUs, page: () => AboutUsPage()),
    GetPage(name: AppPageRoute.privacyPolicy, page: () => PrivacyPolicyPage()),
    GetPage(
      name: AppPageRoute.termsAndCondition,
      page: () => TermsAndConditionPage(),
    ),
  ];
}
