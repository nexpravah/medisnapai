import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

import '/common_imports.dart';

class HomeController extends AppController {
  RxString deviceId = ''.obs;
  RxString deviceType = ''.obs;
  RxString token = ''.obs;
  RxString username = ''.obs;

  Future<void> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId.value = androidInfo.id ?? 'Unknown';
      deviceType.value = 'Android';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId.value = iosInfo.identifierForVendor ?? 'Unknown';
      deviceType.value = 'iOS';
    }

    if (GetStorage().read(AppStorageKey.token) == null) {
      GetStorage().write(AppStorageKey.deviceId, deviceId.value);
      GetStorage().write(AppStorageKey.deviceType, deviceType.value);
      await makeRequest();
    } else {
      deviceId.value = GetStorage().read(AppStorageKey.deviceId);
      deviceType.value = GetStorage().read(AppStorageKey.deviceType);
      token.value = GetStorage().read(AppStorageKey.token);
      username.value = GetStorage().read(AppStorageKey.username);
    }
  }

  Future<void> makeRequest() async {
    final url = Uri.parse(AppApis.token);
    final response = await http.get(
      url,
      headers: {'Device-Id': deviceId.value, 'App-Type': deviceType.value},
    );

    if (response.statusCode == 201) {
      final resJson = jsonDecode(response.body);
      GetStorage().write(AppStorageKey.token, resJson['result']['token']);
      GetStorage().write(AppStorageKey.username, resJson['result']['username']);
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  void onInit() async {
    await getDeviceInfo();
    super.onInit();
  }
}
