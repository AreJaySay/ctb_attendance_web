import 'dart:math';

import 'package:ctb_attendance_monitoring/models/user.dart';
import 'package:ctb_attendance_monitoring/services/apis/announcement.dart';
import 'package:ctb_attendance_monitoring/services/apis/notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/palettes/app_colors.dart' hide Colors;
import '../../utils/snackbars/snackbar_message.dart';
import '../../widgets/button.dart';

class AddAnnouncement extends StatefulWidget {
  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  final TextEditingController _content = new TextEditingController();
  final Materialbutton _materialbutton = new Materialbutton();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final AnnouncementApis _announcementApis = new AnnouncementApis();
  final NotificationApis _notificationApis = new NotificationApis();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;
  String _type = "";
  DateTime? _date;

  @override
  void dispose() {
    // TODO: implement dispose
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 550,
        height: 500,
        child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create Announcement",style: TextStyle(fontFamily: "OpenSans", fontSize: 16, fontWeight: FontWeight.w600),),
                SizedBox(
                  height: 30,
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
                      'School accouncement',
                      'Teachers meeting',
                      'General meeting',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                      );
                    }).toList(),
                    hint: Text(_type.isEmpty
                        ? 'Announcement type'
                        : _type,style: TextStyle(fontFamily: "OpenSans",fontSize: 16, color: _type.isEmpty ? Colors.grey : Colors.black),),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _type = value;
                        });
                        print(_type);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          _selectDate(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1000),
                            border: Border.all(color: colors.blue.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.today, color: colors.blue, size: 23,),
                              SizedBox(
                                width: 10,
                              ),
                              Text("${_date != null ? "${DateFormat.yMMMd().format(_date!)}" : "Select date"}", style: TextStyle(color: _date == null ? Colors.grey : Colors.black, fontFamily: "OpenSans",fontSize: 15),),
                              Spacer(),
                              Icon(Icons.arrow_drop_down_sharp)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          _selectTime(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1000),
                            border: Border.all(color: colors.blue.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time, color: colors.blue, size: 23,),
                              SizedBox(
                                width: 10,
                              ),
                              Text("${_selectedTime != null ? "${_selectedTime!.format(context)}" : "Select time"}", style: TextStyle(color: _selectedTime == null ? Colors.grey : Colors.black, fontFamily: "OpenSans",fontSize: 15),),
                              Spacer(),
                              Icon(Icons.arrow_drop_down_sharp)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _content,
                  maxLines: 5,
                  style: TextStyle(fontFamily: "OpenSans"),
                  decoration: InputDecoration(
                    hintText: "Announcement content (optional)",
                    hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                    focusedBorder:OutlineInputBorder(
                      borderSide: BorderSide(color: colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Spacer(),
                _isLoading ?
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                      color: colors.blue,
                      borderRadius: BorderRadius.circular(1000)
                  ),
                  child: Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,),
                      )
                  ),
                ) :
                _materialbutton.materialButton("Submit", ()async{
                  setState(() {
                    if(_type == "" || _date == null || _selectedTime == null){
                      _snackbarMessage.snackbarMessage(context, message: "All field are required." ,is_error: true);
                    }else{
                      Map _payload = {
                        "unique_id": "${10000 + Random().nextInt(90000)}",
                        "date": "$_date",
                        "time": "${_selectedTime.hour}:${_selectedTime.minute}",
                        "type": _type,
                        "content": _content.text,
                        "sender": userModel.loggedUser.value["type"],
                        "receiver": _type == "Teachers meeting" ? "teachers" : "students & teachers"
                      };
                      _isLoading = true;
                      Future.delayed(const Duration(seconds: 2), () async{
                        _announcementApis.add(payload: _payload).whenComplete((){
                          _notificationApis.add(payload: _payload);
                          Navigator.of(context).pop(null);
                          _snackbarMessage.snackbarMessage(context, message: "New announcement successfully created!");
                        });
                      });
                    }
                  });
                }, isWhiteBck: false),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          Positioned(
            right: -40,
            top: -35,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: colors.blue,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(), // Initial date shown in the picker
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2100), // Latest selectable date
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }
}
