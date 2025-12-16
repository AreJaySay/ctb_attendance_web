import 'dart:math';

import 'package:ctb_attendance_monitoring/models/students.dart';
import 'package:ctb_attendance_monitoring/services/apis/reports.dart';
import 'package:ctb_attendance_monitoring/utils/snackbars/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/user.dart';
import '../../../services/apis/notifications.dart';
import '../../../utils/palettes/app_colors.dart' hide Colors;
import '../../../widgets/button.dart';

class ReportForm extends StatefulWidget {
  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final TextEditingController _content = new TextEditingController();
  final Materialbutton _materialbutton = new Materialbutton();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final NotificationApis _notificationApis = new NotificationApis();
  final ReportsApis _reportsApis = new ReportsApis();
  String _student = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 550,
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text("Create New Report",style: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.bold),),
          SizedBox(
            height: 20,
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
                if(studentsModel.value.isNotEmpty)...{
                  for(int x = 0; x < studentsModel.value.length; x++)...{
                    "${studentsModel.value[x]["name"]}"
                  }
                },
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                );
              }).toList(),
              hint: Text(_student.isEmpty
                  ? 'Student name'
                  : _student,style: TextStyle(fontFamily: "OpenSans",fontSize: 16, color: _student.isEmpty ? Colors.grey : Colors.black),),
              borderRadius: BorderRadius.circular(10),
              underline: SizedBox(),
              isExpanded: true,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _student = value;
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.blue.withOpacity(0.1)),
                borderRadius: BorderRadius.all(Radius.circular(1000)),
              ),
            ),
            child: StreamBuilder(
                stream: reportTypeHelper.subject,
                builder: (context, snapshot) {
                  return DropdownButton<String>(
                    focusColor: Colors.white,
                    style: TextStyle(fontFamily: "OpenSans",fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    items: <String>[
                      'Academic Performance Report',
                      'Attendance Report',
                      'Behavior / Discipline Report',
                      'Progress Monitoring Report (PMR)',
                      'Social–Emotional Development Report',
                      'Skills/Competency Report (CBE)',
                      'Parent–Teacher Communication Report',
                      'Special Education / IEP Monitoring Report',
                      'Health & Wellness Report',
                      'Holistic Student Development Report',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15, color: Colors.black),),
                      );
                    }).toList(),
                    hint: !snapshot.hasData ? Text('Report type') : Text(snapshot.data!.isEmpty
                        ? 'Report type'
                        : snapshot.data!,style: TextStyle(fontFamily: "OpenSans",fontSize: 16, color: snapshot.data!.isEmpty ? Colors.grey : Colors.black),),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        reportTypeHelper.update(data: value);
                      }
                    },
                  );
                }
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _content,
            style: TextStyle(fontFamily: "OpenSans"),
            keyboardType: TextInputType.text,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Content',
              hintStyle: TextStyle(color: Colors.grey,fontFamily: "OpenSans",fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.blue.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.blue.withOpacity(0.4)),
              ),
            ),
            onChanged: (text) {

            },
          ),
          Spacer(),
          _materialbutton.materialButton("Submit", (){
            Map _payload = {
              "unique_id": "${10000 + Random().nextInt(90000)}",
              "email": userModel.loggedUser.value["email"],
              "type": reportTypeHelper.value,
              "content": _content.text,
              "guardian_id": "",
              "guardian": "",
              "student_name": _student,
              "student_year": userModel.loggedUser.value["students_handled_grade"],
              "student_section": userModel.loggedUser.value["students_handled_section"],
              "date": "${DateTime.now()}",
              "sender": userModel.loggedUser.value["type"],
              "receiver": "students"
            };
            if(_student == "" || reportTypeHelper.value == "" || _content.text.isEmpty){
              _snackbarMessage.snackbarMessage(context, message: "All fields are required.", is_error: true);
            }else{
              print(_payload);
              _reportsApis.add(payload: _payload).whenComplete((){
                _notificationApis.add(payload: _payload);
                Navigator.of(context).pop(null);
                _snackbarMessage.snackbarMessage(context, message: "New report successfully created!");
              });
            }
          }),
        ],
      ),
    );
  }
}

class ReportTypeHelper{
  BehaviorSubject<String> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  String get value => subject.value;

  update({required String data}){
    subject.add(data);
  }
}
final ReportTypeHelper reportTypeHelper = new ReportTypeHelper();