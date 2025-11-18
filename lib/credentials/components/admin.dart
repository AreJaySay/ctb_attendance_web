import 'dart:ui';
import 'package:ctb_attendance_monitoring/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/landing.dart';
import '../services/routes.dart';
import '../utils/palettes/app_colors.dart' hide Colors;
import '../widgets/curve.dart';

class RegisterPage extends StatefulWidget {
  final String type;
  RegisterPage({required this.type});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Routes _routes = new Routes();
  final Materialbutton _materialbutton = new Materialbutton();
  final TextEditingController _fname = new TextEditingController();
  final TextEditingController _lname = new TextEditingController();
  final TextEditingController _age = new TextEditingController();
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _teacherid = TextEditingController();
  String _department = "";
  String _year = "";
  String _base64 = "";
  bool _showPassword = true;
  String _userValidation = "";
  String _passValidation  = "";
  bool _isLoading = false;

  Future _RegisterPage({required String user, required String pass})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user);
    prefs.setString('password', pass);
    _routes.navigator_pushreplacement(context, Landing());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create new account!",style: TextStyle(fontFamily: "OpenSans",fontSize: 32),),
        SizedBox(
          height: 30,
        ),
        Text("Username",style: TextStyle(fontFamily: "regular",fontSize: 16,color: Colors.black),),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: _username,
          style: TextStyle(fontFamily: "OpenSans"),
          decoration: InputDecoration(
            hintText: "Enter username",
            hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
            focusedBorder:OutlineInputBorder(
              borderSide: BorderSide(color: colors.blue, width: 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        _userValidation == "" ? Container() : Row(
          children: [
            Icon(Icons.error_outline,color: Colors.red,),
            SizedBox(
              width: 5,
            ),
            Text(_userValidation,style: TextStyle(fontFamily: "OpenSans",color: Colors.red),)
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text("Password",style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: _password,
          style: TextStyle(fontFamily: "OpenSans"),
          decoration: InputDecoration(
            hintText: "Enter password",
            hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
            focusedBorder:OutlineInputBorder(
              borderSide: BorderSide(color: colors.blue, width: 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIcon: IconButton(
              icon: !_showPassword ? Icon(Icons.visibility_off,color: Colors.grey.shade700,) : Icon(Icons.visibility,color: Colors.grey.shade700,),
              onPressed: (){
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
          ),
          obscureText: _showPassword,
        ),
        SizedBox(
          height: 5,
        ),
        _passValidation == "" ? Container() : Row(
          children: [
            Icon(Icons.error_outline,color: Colors.red,),
            SizedBox(
              width: 5,
            ),
            Text(_passValidation,style: TextStyle(fontFamily: "OpenSans",color: Colors.red),)
          ],
        ),
        _isLoading ?
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              color: colors.blue,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Center(
              child: CircularProgressIndicator(color: Colors.white,)
          ),
        ) :
        _materialbutton.materialButton("Submit", ()async{
          // setState(() {
          //   _userValidation = "";
          //   _passValidation = "";
          //   if(_username.text.isEmpty){
          //     _userValidation = "Username is required.";
          //   }else if(_username.text != "superadmin"){
          //     _userValidation = "Username is invalid, please check and try again.";
          //   }else if(_password.text.isEmpty){
          //     _passValidation = "Password is required.";
          //   }else if(_password.text != "password"){
          //     _passValidation = "Password is invalid, please check and try again.";
          //   }else{
          //     _isLoading = true;
          //     Future.delayed(const Duration(seconds: 5), () async{
          //       _isLoading = false;
          //       _RegisterPage(user: _username.text, pass: _password.text);
          //     });
          //   }
          // });
        }, isWhiteBck: false)
      ],
    );
  }
}
