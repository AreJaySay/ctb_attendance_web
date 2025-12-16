import 'package:ctb_attendance_monitoring/models/Notifications.dart';
import 'package:ctb_attendance_monitoring/models/user.dart';
import 'package:ctb_attendance_monitoring/services/apis/announcement.dart';
import 'package:ctb_attendance_monitoring/services/apis/notifications.dart';
import 'package:ctb_attendance_monitoring/utils/palettes/app_colors.dart' hide Colors;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/appbar.dart';
import '../../widgets/no_data_widget.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationApis _notificationApis = new NotificationApis();
  List? _notifications;
  List? _toSearch;
  bool _isLoading = true;

  Future _get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('notifications');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          setState(() {
            _notifications = data.values.where((s) => s["receiver"] == "admin").toList();
            _toSearch = _notifications;
            _isLoading = false;
          });
          print("NOTIFICATIONS jkjkjkjkjkjkjkjkjkjkjk ${_notifications}");
        } else if (data is List) {
          setState(() {
            _notifications = data;
            _toSearch = _notifications;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _notifications = null;
          _toSearch = null;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.grey.shade200,
          centerTitle: false,
          backgroundColor: Colors.white,
          flexibleSpace: Appbar(title: "NOTIFICATIONS", type: "Notifications", onchange: (text) {
            setState(() {
              List _res = _toSearch!.where((s) => s["type"].toString().toLowerCase().contains(text.toLowerCase())).toList();
             _notifications = _res;
            });
          }, onTeacherTab: (v){}, onPrint: (){}, hasAddButton: false, hasTabs: false, onAdd: (){}),
        ),
        body: _isLoading ?
        Center(
          child: CircularProgressIndicator(color: colors.blue,),
        ) : _notifications!.isEmpty ?
        NoDataWidget() :
        ListView.builder(
          itemCount: _notifications!.length,
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                _notificationApis.seen(id: _notifications![index]['id']);
              },
              child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _notifications![index]["is_read"] == "0" ? colors.lightblue.withOpacity(0.4) : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200)
                    )
                  ),
                  child: _widget(details: _notifications![index])
              ),
            );
          },
        )
    );
  }

  Widget _widget({required Map details}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Icon(Icons.notifications_active_outlined, color: colors.lightblue,),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${details["type"]}",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w500),),
                  Spacer(),
                  Icon(Icons.access_time, size: 20, color: Colors.grey,),
                  SizedBox(
                    width: 5,
                  ),
                  Text("${DateFormat("dd MMM yyyy h:mm a").format(DateTime.parse(details["created_at"]))}",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey),),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 5,
              ),
              Text("${details["content"]}",style: TextStyle(fontFamily: "OpenSans", fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis,),
            ],
          ),
        ),
      ],
    );
  }

  String formatTimeOfDayManually() {
    final TimeOfDay currentTimeOfDay = TimeOfDay.fromDateTime(DateTime.now()  );
    final hour = currentTimeOfDay.hour.toString().padLeft(2, '0');
    final minute = currentTimeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute'; // e.g., "09:30" or "22:15"
  }
}
