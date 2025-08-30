import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common_imports.dart';
import 'controllers/api_controller.dart';
import 'controllers/history_controller.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});
  final HistoryController _historyController = Get.put(HistoryController());
  final ApiController _apiController = Get.find<ApiController>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _historyController.getHistory();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("History"), centerTitle: true),
      body: Obx(() {
        if (_historyController.items.isEmpty &&
            _historyController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
    
        return RefreshIndicator(
          onRefresh: () async {
            _historyController.isLoading.value = false;
            _historyController.isMoreDataAvailable.value = true;
            _historyController.page = 1;
            await _historyController.getHistory(isFirstLoad: true);
          },
    
          child: ListView.builder(
            controller: _scrollController,
            itemCount:
                _historyController.items.length +
                (_historyController.isMoreDataAvailable.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _historyController.items.length) {
                final item = _historyController.items[index];
                final response = item["response"];
                final imageUrl = AppApis.host + (item["image"] ?? "");
                final name = response?["name"] ?? "No name";
                final createAt = DateTime.parse(item["created_at"]).toLocal();
    
                return ListTile(
                  leading: InkWell(
                    onTap: () {
                      Get.dialog(
                        Stack(
                          children: [
                            Positioned(
                              top: 20,
                              right: 10,
                              child: IconButton(
                                onPressed: () {
                                  Get.close(1);
                                },
                                icon: Icon(Icons.close, size: 40),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: Get.width / 1.2,
                                height: Get.height / 1.4,
                                child: Card(
                                  child: CustomCachedNetworkImage(
                                    imageUrl: imageUrl,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: CustomCachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  title: Text(name),
                  subtitle: Text(
                    "${createAt.day}/${createAt.month}/${createAt.year} ${createAt.hour}:${createAt.minute}",
                  ),
                  onTap: () {
                    if (item["response"]["type"] == 1) {
                      AppDialog.alertDialog(title: item['response']['name']);
                    } else {
                      var newMap = {
                        for (var e in item.entries)
                          e.key == 'response' ? 'result' : e.key: e.value,
                      };
                      _apiController.medicineResponse.value = newMap;
                      Get.toNamed(AppPageRoute.details);
                    }
                  },
                );
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        );
      }),
    );
  }
}

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width = 350,
    this.height = 150,
  });

  final String imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl, // Example image URL
      fit: BoxFit.cover,
      imageBuilder:
          (context, imageProvider) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
      placeholder:
          (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!, // Starting color of the shimmer
            highlightColor: Colors.grey[100]!, // Highlight color of the shimmer
            child: Container(
              width: width, // Match the expected image width
              height: height, // Match the expected image height
              color:
                  Colors
                      .white, // Color of the shimmer base (what it's "shimmering" over)
            ),
          ),
      errorWidget: (context, url, error) => const Icon(Icons.error, size: 50),
    );
  }
}
