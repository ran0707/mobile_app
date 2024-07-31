import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp01/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:testapp01/bloc/phone_verification/phone_verification_bloc.dart';
import 'package:testapp01/localization/app_localizations.dart';
import 'package:testapp01/screens/landing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp01/bloc/language_selection/language_bloc.dart';
import 'package:testapp01/bloc/language_selection/language_state.dart';
import 'package:testapp01/screens/userAuth/languageSelection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';




//color constants
const Color primaryColor = Color(0xff040403); //medium green 0xFF4caf50
const Color secondaryColor = Color(0xff5b7553); //light yellow 0xFFffeb3b
const Color accentColor1 = Color(0xff919191); // soft brown 0xff8d6e63
const Color accentColor2 = Color(0xFFc3e8bd); // medium purple 0xFF7e57c2
const Color neutralColor = Color(0xFFffffff); //white 0xFFffffff


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // it is used to initialize the app
  SharedPreferences prefs = await SharedPreferences.getInstance(); // store the token
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;



  //String? selectedLanguage = prefs.getString('selectedLanguage') ?? ' ';

  runApp(MyApp(
    isFirstTime: isFirstTime,
    //selectedLanguage: selectedLanguage,// used to get the token for app
  ));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
 // final String selectedLanguage;

  const MyApp({super.key, required this.isFirstTime,   });


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_)=>LanguageBloc()),
          BlocProvider(create: (context) => PhoneVerificationBloc()),
          BlocProvider(create: (context)=> OtpVerificationBloc()),
        ],
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state){
            Locale locale = state is LanguageSelected ? Locale(state.selectedLanguage): const Locale('en');
            // String localeCode = 'en';
            // if(state is LanguageSelected){
            //   localeCode = state.selectedLanguage;
            // }
            // Locale locale = Locale(localeCode);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Green Camellia',
              locale: locale,
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('ta', 'IN'),
              ],
              localizationsDelegates:  [
                FlutterI18nDelegate(
                  translationLoader: FileTranslationLoader(
                    useCountryCode: false,
                    fallbackFile: 'en',
                    basePath: 'assets/lang',
                  ),
                ),

                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: ThemeData(
                primaryColor: primaryColor,
                colorScheme: ColorScheme(
                  primary: primaryColor,
                  secondary: secondaryColor,
                  surface: neutralColor,
                  background: neutralColor,
                  error: Colors.red,
                  onPrimary: Colors.white,
                  onSecondary: Colors.black,
                  onSurface: Colors.black,
                  onBackground: Colors.black,
                  onError: Colors.white,
                  brightness: Brightness.light,
                ),
                hintColor: accentColor1,
                secondaryHeaderColor: accentColor2,
                scaffoldBackgroundColor: neutralColor,
              ),
              home:
                  isFirstTime ? Landing() : LanguageSelection(),
            );
          },

        )


    );

  }

}
