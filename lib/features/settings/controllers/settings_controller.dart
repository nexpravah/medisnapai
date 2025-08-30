import 'package:webview_flutter/webview_flutter.dart';
import '/common_imports.dart';

class SettingsController extends AppController {
  // Error flags for UI to observe
  final RxBool privacyPolicyHasError = false.obs;
  final RxBool termsAndConditionsHasError = false.obs;
  final RxBool aboutUsHasError = false.obs;

  // WebViewControllers
  late final WebViewController privacyPolicyController;
  late final WebViewController termsAndConditionController;
  late final WebViewController aboutUsController;

  SettingsController() {
    privacyPolicyController = _createWebViewController(
      url: "${AppApis.rootUrl}/m/privacy-policy/", errorFlag: privacyPolicyHasError);
    termsAndConditionController = _createWebViewController(
      url: "${AppApis.rootUrl}/m/terms-and-conditions/",
      errorFlag: termsAndConditionsHasError,
    );
    aboutUsController = _createWebViewController(
      url: "${AppApis.rootUrl}/m/about/", errorFlag: aboutUsHasError);
  }

  WebViewController _createWebViewController({required String url, required RxBool errorFlag}) {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Optional: implement progress bar
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              // onHttpError: (HttpResponseError error) {
              //   errorFlag.value = true;
              // },
              // onWebResourceError: (WebResourceError error) {
              //   errorFlag.value = true;
              // },
              onNavigationRequest: (NavigationRequest request) {
                // if (request.url.startsWith(AppApis.rootUrl)) {
                //   return NavigationDecision.prevent;
                // }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(url));

    return controller;
  }
}
