import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'controllers/api_controller.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({super.key});
  final apiController = Get.find<ApiController>();

  // 🎨 Define custom colors for each section
  final Map<String, Color> sectionColors = {
    "What it is": Colors.deepPurple,
    "Uses": Colors.green,
    "How to Use": Colors.orange,
    "Important to Know": Colors.redAccent,
    "When to be Careful": Colors.teal,
    "Possible Side Effects": Colors.brown,
  };

  // 🎯 Define custom icons for each section
  final Map<String, IconData> sectionIcons = {
    "What it is": Icons.info_outline,
    "Uses": Icons.medical_services_outlined,
    "How to Use": Icons.bookmark_added_outlined,
    "Important to Know": Icons.warning_amber_outlined,
    "When to be Careful": Icons.shield_outlined,
    "Possible Side Effects": Icons.sick_outlined,
  };

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
            adUnitId: 'ca-app-pub-3940256099942544/1033173712',
            request: const AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {
                    ad.dispose();
                    Get.back();
                  },
                  onAdFailedToShowFullScreenContent: (ad, error) {
                    ad.dispose();
                    Get.back();
                  },
                );
                ad.show();
              },
              onAdFailedToLoad: (error) {
                Get.back();
              },
            ),
          );
          return false;
        } else {
          apiController.adWatchCount.value++;
          Get.back();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Medicine Details", style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medicine Name Header
              Center(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16.0),

              if (whatItIs.isNotEmpty) _infoCard(title: "What it is", content: _sectionContent(whatItIs)),

              if (uses.isNotEmpty) _infoCard(title: "Uses", content: Column(children: uses.map((e) => _bulletItem(e)).toList())),

              if (howToUse.isNotEmpty) _infoCard(title: "How to Use", content: _sectionContent(howToUse)),

              if (thingsToKnow.isNotEmpty)
                _infoCard(title: "Important to Know", content: Column(children: thingsToKnow.map((e) => _bulletItem(e)).toList())),

              if (whenToBeCareful.isNotEmpty)
                _infoCard(title: "When to be Careful", content: Column(children: whenToBeCareful.map((e) => _bulletItem(e)).toList())),

              if (possibleSideEffects.isNotEmpty)
                _infoCard(
                  title: "Possible Side Effects",
                  content: Column(children: possibleSideEffects.map((e) => _bulletItem(e)).toList()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Card with dynamic color + icon
  Widget _infoCard({required String title, required Widget content}) {
    final color = sectionColors[title] ?? Colors.blueGrey;
    final icon = sectionIcons[title] ?? Icons.description_outlined;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
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
        children: [
          const Text("• ", style: TextStyle(fontSize: 18.0, color: Colors.black54)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16.0))),
        ],
      ),
    );
  }
}
