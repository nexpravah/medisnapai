import 'package:webview_flutter/webview_flutter.dart';

import '../../../common_imports.dart';
import '../controllers/settings_controller.dart';

class AboutUsPage extends StatelessWidget {
  AboutUsPage({super.key});
  final settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("about_us".tr)),
      body: Obx(() {
        if (settingsController.aboutUsHasError.value) {
          return Center(child: Text("page_load_error".tr));
        }
        return WebViewWidget(controller: settingsController.aboutUsController);
      }),
    );
  }
}
