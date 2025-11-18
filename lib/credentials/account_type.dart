import 'package:ctb_attendance_monitoring/credentials/register.dart';
import 'package:ctb_attendance_monitoring/utils/palettes/app_colors.dart';
import 'package:flutter/material.dart';

import '../../widgets/button.dart';

class AccountType extends StatefulWidget {
  @override
  State<AccountType> createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  final Materialbutton _materialbutton = new Materialbutton();
  bool _goToForm = false;
  String _type = "";

  @override
  Widget build(BuildContext context) {
    return _goToForm ?
    RegisterPage(type: _type,) :
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose type of account!",style: TextStyle(fontFamily: "OpenSans",fontSize: 32),),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(color: colors.lightblue),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Checkbox(
                  activeColor: colors.blue,
                  value: _type == "teacher",
                  onChanged: (value){
                    setState(() {
                      _type = "teacher";
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Image(
                  width: 23,
                  image: AssetImage("assets/icons/type_teacher.png"),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Teacher",style: TextStyle(fontFamily: "OpenSans",fontSize: 16),)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border.all(color: colors.lightblue),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Checkbox(
                  activeColor: colors.blue,
                  value: _type == "admin",
                  onChanged: (value){
                    setState(() {
                      _type = "admin";
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Image(
                  width: 23,
                  image: AssetImage("assets/icons/type_admin.png"),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Admin",style: TextStyle(fontFamily: "OpenSans",fontSize: 16),)
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          _materialbutton.materialButton("Continue", ()async{
            setState(() {
              _goToForm = true;
            });
          }, isWhiteBck: false, isvalidated: _type != ""),
        ],
    );
  }
}
