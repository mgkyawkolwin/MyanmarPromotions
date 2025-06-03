import 'dart:io';
import 'package:flutter/foundation.dart';
class AdHelper {

  //Google Test Ads
  //App Open	ca-app-pub-3940256099942544/3419835294
  //Banner	ca-app-pub-3940256099942544/6300978111
  //Interstitial	ca-app-pub-3940256099942544/1033173712
  //Interstitial Video	ca-app-pub-3940256099942544/8691691433
  //Rewarded	ca-app-pub-3940256099942544/5224354917
  //Rewarded Interstitial	ca-app-pub-3940256099942544/5354046379
  //Native Advanced	ca-app-pub-3940256099942544/2247696110
  //Native Advanced Video	ca-app-pub-3940256099942544/1044960115

  //Banner
//Test ID => ca-app-pub-3940256099942544/6300978111
//Real ID => ca-app-pub-1388496165765791/9598889620

//Interstitial
//Test ID => ca-app-pub-1388496165765791~4781345048
//Read ID => ca-app-pub-1388496165765791/3573959177

//App Open
//Test ID => ca-app-pub-1388496165765791~4781345048
//Real ID => ca-app-pub-1388496165765791/9161327777
//ca-app-pub-1388496165765791/8558905544
//ca-app-pub-1388496165765791/3741693132
//ca-app-pub-1388496165765791/9732386415
//ca-app-pub-1388496165765791/5409998027
//ca-app-pub-1388496165765791/7755932090

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/8558905544';
      }
    } else if (Platform.isIOS) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/8558905544';
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAlternateAdUnitId {
    if (Platform.isAndroid) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/7755932090';
      }
    } else if (Platform.isIOS) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/7755932090';
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get detailAdUnitId {
    if (Platform.isAndroid) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/5409998027';
      }
    } else if (Platform.isIOS) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/5409998027';
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get walletAdUnitId {
    if (Platform.isAndroid) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/9732386415';
      }
    } else if (Platform.isIOS) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/9732386415';
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get newPromotionAdUnitId {
    if (Platform.isAndroid) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/8161831630';
      }
    } else if (Platform.isIOS) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get profileAdUnitId {
    if (Platform.isAndroid) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/3741693132';
      }
    } else if (Platform.isIOS) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-1388496165765791/3741693132';
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/2247696110';
      } else {
        return 'ca-app-pub-1388496165765791/6986400628';
      }
    } else if (Platform.isIOS) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/2247696110';
      } else {
        return 'ca-app-pub-1388496165765791/6986400628';
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
