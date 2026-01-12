import 'dart:io';
import 'package:ctb_attendance_monitoring/credentials/login.dart';
import 'package:ctb_attendance_monitoring/credentials/components/admin.dart';
import 'package:ctb_attendance_monitoring/models/teachers.dart';
import 'package:ctb_attendance_monitoring/models/user.dart';
import 'package:ctb_attendance_monitoring/screens/landing.dart';
import 'package:ctb_attendance_monitoring/services/apis/admin.dart';
import 'package:ctb_attendance_monitoring/services/apis/teachers.dart';
import 'package:ctb_attendance_monitoring/services/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/firebase_options.dart';
import 'models/converter.dart';
import 'models/admin.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catbalogan V Attendance Monitoring',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('en', 'EN'),
      supportedLocales: [
        Locale('en', 'EN'),
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TeacherApis _teacherApis = new TeacherApis();
  final AdminApis _adminApis = new AdminApis();
  final Routes _routes = new Routes();

  @override
  void initState() {
    // TODO: implement initState
    _adminApis.get().whenComplete(()async{
      _teacherApis.get();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Future.delayed(Duration(seconds: 5), ()async {
        List _teacher = teachersModel.value.where((s) => s["email"] == prefs.getString('email') && converterModels.hexToString(s["pass"].tos) == prefs.getString('pass')).toList();
        List _admin = adminModel.value.where((s) => s["email"] == prefs.getString('email') && converterModels.hexToString(s["pass"]) == prefs.getString('pass')).toList();
        print("GET LOGGED USER ${_admin} || ${_teacher}");
        if(_admin.isEmpty && _teacher.isEmpty){
          _routes.navigator_pushreplacement(context, Login());
        }else{
          userModel.updateUser(data: _admin.isNotEmpty ? _admin.first : _teacher.first);
          _routes.navigator_pushreplacement(context, Landing());
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}
