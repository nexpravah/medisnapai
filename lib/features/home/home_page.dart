import 'dart:io';

import 'package:camera/camera.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../settings/controllers/language_controller.dart';
import '../settings/controllers/theme_controller.dart';

import '../../common_imports.dart';
import 'controllers/api_controller.dart';
import 'controllers/get_camera_controller.dart';
import 'controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final themeController = Get.put(ThemeController());
  final languageController = Get.put(LanguageController());
  final homeController = Get.put(HomeController());
  final getCameraController = Get.put(GetCameraController());
  final apiController = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("app_name".tr),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppPageRoute.history);
            },
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed(AppPageRoute.settings);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 5,
            child: Obx(
              () =>
                  getCameraController.isCameraInitialized.value
                      ? SizedBox(
                        height: 600,
                        child:
                            apiController.isLoading.isTrue && getCameraController.capturedImagePath.isNotEmpty
                                ? Image.file(File(getCameraController.capturedImagePath.value))
                                : CameraPreview(getCameraController.controller.value),
                      )
                      : Container(height: 600),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.flip_camera_android),
                  onPressed: () {
                    getCameraController.onCameraFlip();
                  },
                ),
                IconButton(
                  onPressed: () async {
                    final imgPath = await getCameraController.captureImage();
                    if (imgPath != null) {
                      showLoadingDialog();
                      final res = await apiController.getMedicineInfo(imgPath: getCameraController.capturedImagePath.value);
                      Get.close(1);
                      if (res == null) {
                        AppDialog.alertDialog(title: "Please try again.");
                      } else if (res != null && res['result']['type'] == 1) {
                        AppDialog.alertDialog(title: res['result']['name']);
                      } else if (res != null && res['result']['type'] == 0) {
                        Get.toNamed(AppPageRoute.details);
                      } else {
                        AppDialog.alertDialog(title: "Please try again.");
                      }
                    }
                  },
                  icon: const Icon(Icons.camera, size: 80),
                ),

                IconButton(
                  onPressed: () async {
                    final imgPath = await getCameraController.pickImageFromGallery();
                    if (imgPath != null) {
                      showLoadingDialog();
                      final res = await apiController.getMedicineInfo(imgPath: getCameraController.capturedImagePath.value);
                      Get.close(1);
                      if (res == null) {
                        AppDialog.alertDialog(title: "Please try again.");
                      } else if (res != null && res['result']['type'] == 1) {
                        AppDialog.alertDialog(title: res['result']['name']);
                      } else if (res != null && res['result']['type'] == 0) {
                        Get.toNamed(AppPageRoute.details);
                      } else {
                        AppDialog.alertDialog(title: "Please try again.");
                      }
                    }
                  },
                  icon: const Icon(Icons.photo_library),
                ),
              ],
            ),
          ),
          BannerAdWidget(),
        ],
      ),
    );
  }
}

void showLoadingDialog() {
  Get.dialog(
    WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.3), // Dimmed background
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Loading, please wait...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false, // Prevent tap outside
  );
}

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? SizedBox(width: _bannerAd!.size.width.toDouble(), height: _bannerAd!.size.height.toDouble(), child: AdWidget(ad: _bannerAd!))
        : const SizedBox.shrink();
  }
}
