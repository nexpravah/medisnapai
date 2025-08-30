import 'package:webview_flutter/webview_flutter.dart';
import '../../../common_imports.dart';
import '../controllers/settings_controller.dart';

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({super.key});
  final settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("privacy_policy".tr)),
      body: Obx(() {
        if (settingsController.privacyPolicyHasError.value) {
          return Center(child: Text("page_load_error".tr));
        }
        return WebViewWidget(
          controller: settingsController.privacyPolicyController,
        );
      }),
    );
  }
}
