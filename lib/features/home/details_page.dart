import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../common_imports.dart';
import 'controllers/api_controller.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({super.key});
  final apiController = Get.find<ApiController>();

  @override
  Widget build(BuildContext context) {
    final result = apiController.medicineResponse['result'];

    final name = result['name'] ?? 'Details';
    final whatItIs = result['what_it_is'] ?? '';
    final uses = (result['uses'] as List?) ?? [];
    final howToUse = result['how_to_use'] ?? '';
    final thingsToKnow = (result['things_to_know'] as List?) ?? [];
    final whenToBeCareful = (result['when_to_be_careful'] as List?) ?? [];
    final possibleSideEffects = (result['possible_side_effects'] as List?) ?? [];

    return WillPopScope(
      onWillPop: () async {
        if (apiController.adWatchCount.value >= 2) {
          apiController.adWatchCount.value = 0;
          InterstitialAd.load(
            adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Replace with your real Ad Unit ID
            request: const AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {
                    ad.dispose();
                    // Go to home after ad is closed
                    Get.back();
                  },
                  onAdFailedToShowFullScreenContent: (ad, error) {
                    ad.dispose();
                    // Fallback navigation
                    Get.back();
                  },
                );
                ad.show();
              },
              onAdFailedToLoad: (error) {
                print('Ad failed to load: $error');
                // Navigate directly if ad fails to load
                Get.back();
              },
            ),
          );

          return false; // prevent immediate back navigation — wait for ad to finish
        } else {
          apiController.adWatchCount.value++;
          Get.back();
        }
        return true; // Allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Details", style: const TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              _sectionTitle("What it is"),
              _sectionContent(whatItIs),

              if (uses.isNotEmpty) ...[_sectionTitle("Uses"), ...uses.map<Widget>((use) => _bulletItem(use))],

              if (howToUse.isNotEmpty) ...[_sectionTitle("How to use"), _sectionContent(howToUse)],

              if (thingsToKnow.isNotEmpty) ...[
                _sectionTitle("Important to Know"),
                ...thingsToKnow.map<Widget>((item) => _bulletItem(item)),
              ],

              if (whenToBeCareful.isNotEmpty) ...[
                _sectionTitle("When to be Careful"),
                ...whenToBeCareful.map<Widget>((item) => _bulletItem(item)),
              ],

              if (possibleSideEffects.isNotEmpty) ...[
                _sectionTitle("Possible Side Effects"),
                ...possibleSideEffects.map<Widget>((item) => _bulletItem(item)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
    );
  }

  Widget _sectionContent(String content) {
    return Text(content, style: const TextStyle(fontSize: 16.0));
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const Text("• ", style: TextStyle(fontSize: 18.0)), Expanded(child: Text(text, style: const TextStyle(fontSize: 16.0)))],
      ),
    );
  }
}
