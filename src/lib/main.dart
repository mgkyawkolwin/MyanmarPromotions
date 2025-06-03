import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/register.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

//My libraries
import 'library/appdata.dart';
import 'library/CommonAppData.dart';
import 'screens/login.dart';
import 'screens/profile.dart';
import 'screens/favorite.dart';
import 'screens/mypromotions.dart';
import 'screens/wallet.dart';
import 'screens/setting.dart';
import 'screens/change_password.dart';
import 'screens/history.dart';
import 'screens/reset_password.dart';
import 'screens/add_post.dart';
import 'languages/languages.dart';
import 'screens/home.dart';
import 'screens/detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

//ignore: use_key_in_widget_constructors
class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
// Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }


  void initialize() async {
    Map<String, dynamic> userInfoTmp = await AppData.getAppDataAll();
    CommonAppData.userID = userInfoTmp['user_id'];
    CommonAppData.userName = userInfoTmp['user_name'];
    CommonAppData.displayName = userInfoTmp['display_name'];
    CommonAppData.image = userInfoTmp['image'];
  }

  @override
  void initState() {
    initializeFlutterFire();
    // TODO: implement initState
    super.initState();
    initialize();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (_error || !_initialized) {
      return const CircularProgressIndicator();
    }

    return GetMaterialApp(
      translations: LocaleString(),
      locale: const Locale('en', 'US'),
      home: Home(),
      getPages: [
        GetPage(name: '/', page: () => Home()),
        GetPage(name: '/detail', page: () => Detail()),
        GetPage(name: '/add_post', page: () => AddPost()),
        GetPage(name: '/register', page: () => Register()),
        GetPage(name: '/login', page: () => LogIn()),
        GetPage(name: '/profile', page: () => Profile()),
        GetPage(name: '/favorite', page: () => Favorite()),
        GetPage(name: '/mypromotions', page: () => MyPromotions()),
        GetPage(name: '/wallet', page: () => Wallet()),
        GetPage(name: '/setting', page: () => Setting()),
        GetPage(name: '/changepassword', page: () => ChangePassword()),
        GetPage(name: '/resetpassword', page: () => ResetPassword()),
        GetPage(name: '/history', page: () => History()),
      ],
    );
  }

}

