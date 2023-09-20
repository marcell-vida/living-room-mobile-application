import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:living_room/util/navigator.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  initialRoute: "/",
                  title: AppLocalizations.of(context)?.appName ?? '',
                  localizationsDelegates: const [
                    AppLocalizations.delegate, // Add this line
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [Locale('en'), Locale('hu')],
                  theme: ThemeData(
                      textTheme: GoogleFonts.interTextTheme()),
                );
  }
}