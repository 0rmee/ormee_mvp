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

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCoJ45ukyHEATU-Ob75cuxxbfySC3ztQ70",
        authDomain: "ormee-mvp.firebaseapp.com",
        projectId: "ormee-mvp",
        storageBucket: "ormee-mvp.firebasestorage.app",
        messagingSenderId: "796053018584",
        appId: "1:796053018584:web:c5e2fac52820b4992ac4ad",
        measurementId: "G-N69LVJW67P"
    )
  );
  await GetStorage.init();
  Get.put(LectureListController());
  Get.put(TeacherHomeController());
  runApp(const OrmeeApp());
}

class OrmeeApp extends StatelessWidget {
  const OrmeeApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

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
