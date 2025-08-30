import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GetCameraController extends GetxController {
  Rx<CameraController> controller =
      CameraController(
        CameraDescription(name: 'Camera', lensDirection: CameraLensDirection.back, sensorOrientation: 0),
        ResolutionPreset.max,
      ).obs;
  RxList<CameraDescription> cameras = <CameraDescription>[].obs;

  RxInt cameraIndex = 0.obs;
  RxBool isCameraInitialized = false.obs;
  RxString capturedImagePath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future captureImage() async {
    if (!controller.value.value.isInitialized) return;
    try {
      final XFile image = await controller.value.takePicture();
      if (image != null) {
        capturedImagePath.value = image.path;
        update();
        return image.path;
      }
      return null;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  Future pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        capturedImagePath.value = image.path;
        update();
        return image.path;
      }
      return null;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  onCameraFlip() async {
    if (controller.value.value.isInitialized) {
      await controller.value.dispose();
    }
    if (cameraIndex.value == 0) {
      cameraIndex.value = 1;
    } else {
      cameraIndex.value = 0;
    }
    isCameraInitialized.value = false;
    controller.value = CameraController(cameras[cameraIndex.value], ResolutionPreset.max);
    try {
      await controller.value.initialize();
      if (!Get.isRegistered<GetCameraController>()) {
        return;
      }
      isCameraInitialized.value = true;
      update();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          // Handle access errors here.
          break;
        default:
          // Handle other errors here.
          break;
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    cameras.value = await availableCameras();
    controller.value = CameraController(cameras[cameraIndex.value], ResolutionPreset.max);
    try {
      await controller.value.initialize();
      if (!Get.isRegistered<GetCameraController>()) {
        return;
      }
      isCameraInitialized.value = true;
      update();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          // Handle access errors here.
          break;
        default:
          // Handle other errors here.
          break;
      }
    }
  }

  @override
  void onClose() {
    controller.value.dispose();
    super.onClose();
  }
}
