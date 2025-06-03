import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class Admod extends StatefulWidget {
  final String id;
  const Admod(this.id, {Key? key, double? height}) : super(key: key);

  @override
  _AdmodState createState() => _AdmodState();
}

class _AdmodState extends State<Admod> {
  // TODO: Add a BannerAd instance
  late BannerAd _ad;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ad = BannerAd(
      adUnitId: widget.id,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          // print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    // TODO: Load an ad
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AdWidget(ad: _ad),
      width: _ad.size.width.toDouble(),
      height: _ad.size.height.toDouble(),
      alignment: Alignment.center,
    );
  }
}
