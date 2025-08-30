import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'common_imports.dart';
import 'features/settings/controllers/language_controller.dart';
import 'features/settings/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await GetStorage.init();
  await Languages.initTranslations();
  // Set test device ID
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: ['01EEB4ADA1FEB08E5B95D3C8B12CDC6E']),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final languageController = Get.put(LanguageController());
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'app_name'.tr,
        darkTheme: AppThemeData.dark,
        theme: AppThemeData.light,
        themeMode: themeController.themeMode.value,
        initialRoute: AppPageRoute.initialRoute,
        getPages: AppGetPages.list,
        locale: languageController.localLanguage.value,
        translations: Languages(),
      ),
    );
  }
}
