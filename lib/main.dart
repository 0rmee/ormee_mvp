import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ormee_mvp/designs/OrmeeColor.dart';
import 'package:ormee_mvp/screens/branching/view.dart';
import 'package:ormee_mvp/screens/classcode/view.dart';
import 'package:ormee_mvp/screens/lecture_detail/view.dart';
import 'package:ormee_mvp/screens/teacher/home/view_model.dart';
import 'package:ormee_mvp/screens/teacher/main/view.dart';
import 'package:ormee_mvp/screens/teacher/quiz_create/view.dart';
import 'package:ormee_mvp/screens/teacher/quiz_detail/view.dart';
import 'package:ormee_mvp/screens/teacher/sidemenu/view_model.dart';
import 'package:ormee_mvp/screens/teacher/sign_in/view.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
    appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
    measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '',
  ));
  await GetStorage.init();
  Get.put(LectureListController());
  Get.put(TeacherHomeController());
  runApp(const OrmeeApp());
}

class OrmeeApp extends StatelessWidget {
  const OrmeeApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: OrmeeColor.white,
                  statusBarIconBrightness: Brightness.dark))),
      title: 'Ormee',
      initialRoute: '/',
      defaultTransition: Transition.noTransition,
      getPages: [
        GetPage(name: '/', page: () => Branch()),
        GetPage(
          name: '/ClassCode/:lectureId', // URL 경로로 lectureId를 전달
          page: () => LectureDetail(),
        ),
        GetPage(
          name: '/ClassCode',
          page: () => ClassCode(),
        ),
        GetPage(name: '/teacher/signIn', page: () => TeacherSignIn()),
        GetPage(name: '/teacher/main', page: () => TeacherMain()),
        GetPage(name: '/teacher/quiz', page: () => Quizcreate()),
        GetPage(name: '/teacher/quiz/detail', page: () => QuizDetail()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
