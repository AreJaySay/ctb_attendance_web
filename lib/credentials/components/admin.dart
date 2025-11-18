import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:ui';
import 'package:ctb_attendance_monitoring/services/apis/users.dart';
import 'package:ctb_attendance_monitoring/widgets/button.dart';
import 'package:flutter/material.dart';
import '../../services/routes.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;
import '../../utils/snackbars/snackbar_message.dart';
class AdminRegister extends StatefulWidget {
  final Function(String) onBack;
  AdminRegister({required this.onBack});
  @override
  State<AdminRegister> createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  final Routes _routes = new Routes();
  late PageController _pageController;
  final UsersApis _usersApis = new UsersApis();
  final Materialbutton _materialbutton = new Materialbutton();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TextEditingController _fname = new TextEditingController();
  final TextEditingController _lname = new TextEditingController();
  final TextEditingController _age = new TextEditingController();
  final TextEditingController _adminid = new TextEditingController();
  final TextEditingController _phone = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _pass = new TextEditingController();
  final TextEditingController _confirmpass = new TextEditingController();
  String _gender = "";
  bool _showPassword = true;
  bool _showConfirmPassword = true;
  int _currentPage = 0;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fname.dispose();
    _lname.dispose();
    _age.dispose();
    _adminid.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    _confirmpass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              child: Icon(Icons.arrow_back),
              onTap: (){
                widget.onBack("");
              },
            ),
            SizedBox(
              width: 5,
            ),
            Text("Back",style: TextStyle(fontFamily: "OpenSans"),)
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Text("Create Admin Account",style: TextStyle(fontFamily: "OpenSans",fontSize: 25,fontWeight: FontWeight.w600),),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 200,
          child: PageView(
            controller: _pageController,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Firstname",style: TextStyle(fontFamily: "regular",fontSize: 16,color: Colors.black),),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _fname,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: "Enter firstname",
                      hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lastname",style: TextStyle(fontFamily: "regular",fontSize: 16,color: Colors.black),),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _lname,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: "Enter lastname",
                      hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Age",style: TextStyle(fontFamily: "regular",fontSize: 16,color: Colors.black),),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _age,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: "Enter age",
                      hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Admin Id",style: TextStyle(fontFamily: "regular",fontSize: 16,color: Colors.black),),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _adminid,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: "Enter admin id",
                      hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gender",style: TextStyle(fontFamily: "regular",fontSize: 16,color: Colors.black),),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.blue.withOpacity(0.1)),
                        borderRadius: BorderRadius.all(Radius.circular(1000)),
                      ),
                    ),
                    child: DropdownButton<String>(
                      focusColor: Colors.white,
                      style: TextStyle(fontFamily: "OpenSans",fontSize: 16),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      items: <String>[
                        'Male',
                        'Female',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                        );
                      }).toList(),
                      hint: Text(_gender.isEmpty
                          ? 'Enter gender'
                          : _gender,style: TextStyle(fontFamily: "OpenSans",fontSize: 16),),
                      borderRadius: BorderRadius.circular(10),
                      underline: SizedBox(),
                      isExpanded: true,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _gender = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phone number",style: TextStyle(fontFamily: "regular",fontSize: 16,color: Colors.black),),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _phone,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Enter phone number",
                      hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email address",style: TextStyle(fontFamily: "regular",fontSize: 16,color: Colors.black),),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _email,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: "Enter email address",
                      hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Password",style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _pass,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(1000),
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
                    height: 15,
                  ),
                  Text("Confirm password",style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _confirmpass,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: "Confirm password",
                      hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      suffixIcon: IconButton(
                        icon: !_showConfirmPassword ? Icon(Icons.visibility_off,color: Colors.grey.shade700,) : Icon(Icons.visibility,color: Colors.grey.shade700,),
                        onPressed: (){
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _showConfirmPassword,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Visibility(
              visible: _currentPage != 0,
              child: ElevatedButton(
                onPressed: (){
                  setState(() {
                    _currentPage--;
                  });
                  _pageController.animateToPage(
                    _currentPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.black,),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Prev",style: TextStyle(fontFamily: "OpenSans", color: Colors.black),),
                  ],
                ),
              ),
            ),
            Spacer(),
            if(_currentPage == 7)...{
              IgnorePointer(
                ignoring: _isLoading,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.blue,
                  ),
                  onPressed: (){
                    Map _payload = {
                      "fname": _fname.text,
                      "lname": _lname.text,
                      "age": _age.text,
                      "admin_id": _adminid.text,
                      "gender": _gender,
                      "phone": _phone.text,
                      "email": _email.text,
                      "pass": _stringToHex(_pass.text),
                      "base64Image": "",
                    };
                    if(_fname.text.isEmpty || _lname.text.isEmpty || _age.text.isEmpty || _adminid.text.isEmpty || _gender == "" || _phone.text.isEmpty || _email.text.isEmpty || _pass.text.isEmpty){
                      _snackbarMessage.snackbarMessage(context, message: "All fields are required!", is_error: true);
                    }else if(_pass.text != _confirmpass.text){
                      _snackbarMessage.snackbarMessage(context, message: "Password and confirm password did not match!", is_error: true);
                    }else{
                      setState(() {
                        _isLoading = true;
                        Future.delayed(const Duration(seconds: 5), () async{
                          _usersApis.addAdmin(payload: _payload).whenComplete((){
                            _isLoading = false;
                            widget.onBack("account_created");
                            _snackbarMessage.snackbarMessage(context, message: "New admin successfully created!");
                          });
                        });
                      });
                    }
                  },
                  child: _isLoading ?
                  Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ) :
                  Row(
                    children: [
                      Text("Submit",style: TextStyle(fontFamily: "OpenSans",color: Colors.white),),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward,color: Colors.white),
                    ],
                  ),
                ),
              ),
            }else...{
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    _currentPage++;
                  });
                  _pageController.animateToPage(
                    _currentPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                  print(_currentPage);
                },
                child: Row(
                  children: [
                    Text("Next",style: TextStyle(fontFamily: "OpenSans",color: Colors.black),),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.arrow_forward,color: Colors.black),
                  ],
                ),
              ),
            }
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
  String _stringToHex(String input) {
    final bytes = utf8.encode(input);
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}
