import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';
import 'res/routes/routes.dart';
import 'res/values/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
      ),
    );
  }
}
