import 'package:webview_flutter/webview_flutter.dart';
import '../../../common_imports.dart';
import '../controllers/settings_controller.dart';

class TermsAndConditionPage extends StatelessWidget {
  TermsAndConditionPage({super.key});
  final settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("terms_and_condition".tr)),
      body: Obx(() {
        if (settingsController.termsAndConditionsHasError.value) {
          return Center(child: Text("page_load_error".tr));
        }
        return WebViewWidget(
          controller: settingsController.termsAndConditionController,
        );
      }),
    );
  }
}
