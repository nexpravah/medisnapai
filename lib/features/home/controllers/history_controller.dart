import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../common_imports.dart';

class HistoryController extends GetxController {
  final storage = GetStorage();

  var isLoading = false.obs;
  var isMoreDataAvailable = true.obs;
  var page = 1;
  var items = <Map<String, dynamic>>[].obs;

  Future<void> getHistory({bool isFirstLoad = false}) async {
    if (isLoading.value || !isMoreDataAvailable.value) return;
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse("${AppApis.medicine}?page=$page&limit=12"),
        headers: {
          'Authorization': storage.read(AppStorageKey.token),
          'Device-Id': storage.read(AppStorageKey.deviceId),
          'App-Type': storage.read(AppStorageKey.deviceType),
        },
      );

      if (response.statusCode == 200) {
        final resJson = jsonDecode(response.body);
        final results = resJson["result"]["results"] as List;

        if (isFirstLoad) {
          items.assignAll(results.cast<Map<String, dynamic>>());
        } else {
          items.addAll(results.cast<Map<String, dynamic>>());
        }

        if (resJson["result"]["next"] == null) {
          isMoreDataAvailable.value = false;
        } else {
          page++;
        }
      } else {
        print('❌ Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print("❌ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    getHistory(isFirstLoad: true);
    super.onInit();
  }
}
