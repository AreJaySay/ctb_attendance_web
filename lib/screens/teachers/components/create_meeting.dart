import 'package:ctb_attendance_monitoring/services/apis/teachers.dart';
import 'package:ctb_attendance_monitoring/utils/palettes/app_colors.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/snackbars/snackbar_message.dart';
import '../../../widgets/button.dart';

class CreateMeeting extends StatefulWidget {
  @override
  State<CreateMeeting> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  DateTime? _date;
  String _startTime = "";
  String _endTime = "";
  final TextEditingController _venue = new TextEditingController();
  final TextEditingController _content = new TextEditingController();
  final Materialbutton _materialbutton = new Materialbutton();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TeacherApis _teacherApis = new TeacherApis();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:  DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.blue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colors.blue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future _pickTime()async{
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.blue, // header and selected color
            ),
          ),
          child: child!,
        );
      },
    );
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 520,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("CREATE NEW MEETING",style: TextStyle(fontFamily: "OpenSans",fontSize: 15, fontWeight: FontWeight.w700),),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: (){
                      setState(() {
                        _date = null;
                        _startTime = "";
                        _endTime = "";
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _venue,
                style: TextStyle(fontFamily: "OpenSans"),
                decoration: InputDecoration(
                  hintText: 'Meeting venue',
                  hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1000),
                    borderSide: BorderSide(color: colors.blue.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1000),
                    borderSide: BorderSide(color: colors.blue.withOpacity(0.4)),
                  ),
                ),
                onChanged: (text) {

                },
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: (){
                  _selectDate();
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  child: _date != null ?
                  Text("${DateFormat("MMMM dd, yyyy").format(_date!)}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),) :
                  Text("Meeting date",style: TextStyle(color: Colors.grey,fontFamily: "OpenSans",fontSize: 15),),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        _pickTime().then((v){
                          print("TIME ${formatTimeOfDay(v)}");
                          setState(() {
                            _startTime = formatTimeOfDay(v);
                          });
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                        child: _startTime != "" ?
                        Text("${_startTime}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),) :
                        Text("Start time",style: TextStyle(color: Colors.grey,fontFamily: "OpenSans",fontSize: 15),),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        _pickTime().then((v){
                          print("TIME ${formatTimeOfDay(v)}");
                          setState(() {
                            _endTime = formatTimeOfDay(v);
                          });
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                        child: _endTime != "" ?
                        Text("${_endTime}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),) :
                        Text("End time",style: TextStyle(color: Colors.grey,fontFamily: "OpenSans",fontSize: 15),),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
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
                if(_venue.text.isEmpty || _date == null || _startTime == "" || _endTime == "" || _content.text.isEmpty){
                  _snackbarMessage.snackbarMessage(context, message: "All fields are required.", is_error: true);
                }else{
                  Map _payload = {
                    "venue": _venue.text,
                    "date": _date,
                    "start_time": _startTime,
                    "end_time": _endTime,
                    "content": _content,
                  };
                  _teacherApis.addMeeting(payload: _payload).whenComplete((){
                    Navigator.of(context).pop(null);
                    _snackbarMessage.snackbarMessage(context, message: "New meeting successfully created!");
                  });
                }
              }),
            ],
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
  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }
}
