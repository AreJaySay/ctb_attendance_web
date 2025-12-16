import 'package:ctb_attendance_monitoring/models/announcements.dart';
import 'package:ctb_attendance_monitoring/models/user.dart';
import 'package:ctb_attendance_monitoring/screens/announcements/add.dart';
import 'package:ctb_attendance_monitoring/services/apis/announcement.dart';
import 'package:ctb_attendance_monitoring/utils/palettes/app_colors.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/appbar.dart';
import '../../widgets/no_data_widget.dart';

class Announcements extends StatefulWidget {
  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  final AnnouncementApis _announcementApis = new AnnouncementApis();

  @override
  void initState() {
    // TODO: implement initState
    _announcementApis.get();
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
        automaticallyImplyLeading: false,
        flexibleSpace: Appbar(title: "ANNOUNCEMENTS", type: "announcements", onchange: (text) {
          setState(() {
            List _res = announcementsModel.valueSearch.where((s) => s["type"].toString().toLowerCase().contains(text.toLowerCase())).toList();
            announcementsModel.update(data: _res);
          });
        }, onTeacherTab: (v){}, onPrint: (){}, hasAddButton: userModel.loggedUser.value["type"] != "teacher", onAdd: (){
          showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  content: AddAnnouncement()
              )
          );
        }),
      ),
      body: StreamBuilder(
        stream: announcementsModel.subject,
        builder: (context, snapshot) {
          return !snapshot.hasData ?
          Center(
            child: CircularProgressIndicator(color: colors.blue,),
          ) : snapshot.data!.isEmpty ?
          NoDataWidget() :
          ListView.builder(
            itemCount: snapshot.data!.length,
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
            itemBuilder: (context, index){
              return Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.only(bottom: 15, top: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200)
                  )
                ),
                child: snapshot.data![index]["type"] == "General meeting" ?
                      _generalMeeting(details: snapshot.data![index]) :
                      snapshot.data![index]["type"] == "School accouncement" ?
                    _schoolAnnouncement(details: snapshot.data![index]) : SizedBox()
              );
            },
          );
        }
      ),
    );
  }
  // 'School accouncement',
  // 'Teachers meeting',
  // 'General meeting',
  Widget _generalMeeting({required Map details}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage("assets/icons/general_announcement.png"),
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
                  Container(
                    child: Text("${details["type"]}",style: TextStyle(fontFamily: "OpenSans", fontSize: 12, color: Colors.white),),
                    decoration: BoxDecoration(
                        color: colors.grey,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  ),
                  Spacer(),
                  Icon(Icons.access_time, size: 20, color: Colors.grey,),
                  SizedBox(
                    width: 5,
                  ),
                  Text("${DateFormat("dd MMM yyyy").format(DateTime.now())} at ${DateFormat("h:mm a").format(DateTime.now())}", style: TextStyle(fontFamily: "OpenSans", fontSize: 13, color: Colors.grey),),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text("New upcoming general meeting will conduct on ${DateFormat.yMMMMd().format(DateTime.parse(details["date"]))} at ${details["time"]}. Hope to see you there, Thank you!",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w500),),
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

  Widget _schoolAnnouncement({required Map details}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(),
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
                  Container(
                    child: Text("${details["type"]}",style: TextStyle(fontFamily: "OpenSans", fontSize: 12, color: Colors.white),),
                    decoration: BoxDecoration(
                        color: colors.pink,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  ),
                  Spacer(),
                  Icon(Icons.access_time, size: 20, color: Colors.grey,),
                  SizedBox(
                    width: 5,
                  ),
                  Text("${DateFormat("dd MMM yyyy").format(DateTime.now())} at ${DateFormat("h:mm a").format(DateTime.now())}", style: TextStyle(fontFamily: "OpenSans", fontSize: 13, color: Colors.grey),),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text("Attention: New school announcement. Please read carefully. Thank you!",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w500),),
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
