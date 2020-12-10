import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';
import 'res/routes/routes.dart';
import 'res/values/theme.dart';

Future<void> main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
  translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'en.json',
        basePath: 'res/flutter_i18n'),
  );
  await flutterI18nDelegate.load(null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(flutterI18nDelegate));
}

class MyApp extends StatelessWidget {
  
  final FlutterI18nDelegate flutterI18nDelegate;

  MyApp(this.flutterI18nDelegate);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: FirebaseAuth.instance.authStateChanges(),
        ),
      ],
      child: MaterialApp(
        title: 'OTU Companion Hub',
        theme: Themes.mainAppTheme(),
        initialRoute: Routes.loginCheckerPage,
        onGenerateRoute: Routes.generateRoute,
        localizationsDelegates: [
          flutterI18nDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
