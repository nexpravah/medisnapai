import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medilens/common_imports.dart';
import 'package:path/path.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiController extends GetxController {
  var adWatchCount = 0.obs;

  final GetStorage storage = GetStorage();
  RxString language = 'English'.obs;
  List<String> languageList = <String>['English', 'Gujarati', 'Hindi'];

  RxMap<String, dynamic> medicineResponse = <String, dynamic>{}.obs;

  RxBool isLoading = false.obs;
  Future getMedicineInfo({String? imgPath}) async {
    try {
      isLoading.value = true;
      if (imgPath == null || imgPath.isEmpty) {
        print('❌ Image path is null or empty.');
        return;
      }

      final file = File(imgPath);

      if (!await file.exists()) {
        print('❌ File not found at: $imgPath');
        return;
      }

      final uri = Uri.parse(AppApis.medicine);
      print("language: ${GetStorage().read(AppStorageKey.appLanguage)}");
      final request =
          http.MultipartRequest('POST', uri)
            ..headers.addAll({
              'Authorization': storage.read(AppStorageKey.token),
              'Device-Id': storage.read(AppStorageKey.deviceId),
              'App-Type': storage.read(AppStorageKey.deviceType),
            })
            ..fields['language'] = GetStorage().read(AppStorageKey.appLanguage)
            ..files.add(
              await http.MultipartFile.fromPath(
                'image',
                file.path,
                filename: basename(file.path),
              ),
            );

      final response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final resJson = jsonDecode(resBody);
        medicineResponse.value = resJson;

        print('✅ Success: $resBody');
        return resJson;
      } else {
        final error = await response.stream.bytesToString();
        print('❌ Error ${response.statusCode}: $error');
        return;
      }
    } catch (e) {
      print('❌ Exception: $e');
      return;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    if (GetStorage().read("LANGUAGE") != null) {
      language.value = GetStorage().read("LANGUAGE");
    } else {
      language.value = 'English';
    }
    super.onInit();
  }
}
