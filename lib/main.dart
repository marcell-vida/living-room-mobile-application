import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:living_room/service/authentication/authentication_service.dart';
import 'package:living_room/service/database/database_service.dart';
import 'package:living_room/state/app/navigator_bar_cubit.dart';
import 'package:living_room/state/base/app_base_cubit.dart';
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationService>(
            create: (_) => AuthenticationService()),
        RepositoryProvider<DatabaseService>(create: (_) => DatabaseService()),
      ],
      child: Builder(builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AppBaseCubit>(
                create: (context) => AppBaseCubit(
                    authenticationService:
                        RepositoryProvider.of<AuthenticationService>(context),
                    databaseService:
                        RepositoryProvider.of<DatabaseService>(context))),
            BlocProvider<NavigatorBarCubit>(
                create: (context) => NavigatorBarCubit())
          ],
          child: Builder(builder: (context) {
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
              theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
            );
          }),
        );
      }),
    );
  }
}
