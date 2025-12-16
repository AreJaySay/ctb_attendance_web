import 'dart:convert';
import 'package:ctb_attendance_monitoring/functions/loaders.dart';
import 'package:ctb_attendance_monitoring/models/teachers.dart';
import 'package:ctb_attendance_monitoring/screens/teachers/components/create_meeting.dart';
import 'package:ctb_attendance_monitoring/screens/teachers/pending.dart';
import 'package:ctb_attendance_monitoring/services/apis/teachers.dart';
import 'package:ctb_attendance_monitoring/widgets/no_data_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../services/routes.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;
import '../../widgets/appbar.dart';
import '../../widgets/shimmer_loader/table.dart';
import '../teachers/components/edit_modal.dart';
import 'components/delete_modal.dart';

class Teachers extends StatefulWidget {
  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  final Routes _routes = new Routes();
  final TeacherApis _teacherApis = new TeacherApis();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final _scrollController = ScrollController();
  List? _toSearch;
  bool _isTeacherTab = true;

  @override
  void initState() {
    // TODO: implement initState
    _teacherApis.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: teachersModel.subject,
        builder: (context, snapshot) {
          List _teachers = !snapshot.hasData ? [] : snapshot.data!.where((s) => s["status"] == "accepted").toList();

          return Scaffold(
              appBar: AppBar(
                elevation: 1,
                shadowColor: Colors.grey.shade200,
                centerTitle: false,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                flexibleSpace: Appbar(title: "TEACHERS", type: "teachers", hasTabs: true, pendingCount: !snapshot.hasData ? "0" : "${snapshot.data!.where((s) => s["status"] == "pending").toList().length}", onchange: (text) {
                  List _res = teachersModel.valueSearch.where((s) => s["fname"].toString().toLowerCase().contains(text.toLowerCase()) || s["lname"].toString().toLowerCase().contains(text.toLowerCase())).toList();
                  teachersModel.update(data: _res);

                }, hasAddButton: false, onAdd: (){}, onPrint: (){}, onTeacherTab: (v){
                  setState(() {
                    _isTeacherTab = v;
                  });
                },)
              ),
              backgroundColor: Colors.white,
              body: !snapshot.hasData ?
              TableLoader() :
              !_isTeacherTab ?
              PendingTeachers() :
              _teachers.isEmpty ?
              NoDataWidget() :
              Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  child: Table(
                    border: TableBorder.all(color: colors.blue.withOpacity(0.1)),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(150),
                      1: FixedColumnWidth(150),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                      4: FlexColumnWidth(),
                      5: FlexColumnWidth(),
                      6: FlexColumnWidth(),
                      7: FixedColumnWidth(130),
                      8: FixedColumnWidth(100),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                        children: <Widget>[
                          TableCell(child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                            child: Center(child: Text('ID',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold),)),
                          )),
                          TableCell(child: Center(child: Text('Photo',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          TableCell(child: Center(child: Text('Name',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          TableCell(child: Center(child: Text('Age',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          TableCell(child: Center(child: Text('Teacher ID',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          TableCell(child: Center(child: Text('Email address',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          TableCell(child: Center(child: Text('Phone number',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          TableCell(child: Center(child: Text('Gender',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          TableCell(child: Center(child: Text('Action',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                        ],
                      ),
                      for(int x = 0; x < _teachers.length; x++)...{
                        TableRow(
                          decoration: BoxDecoration(
                              color: Colors.white
                          ),
                          children: <Widget>[
                            TableCell(child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                              child: Center(child: Text('${x + 1}',style: TextStyle(fontFamily: "Roboto_normal"))),
                            )),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: _teachers[x]["base64Image"] != "" ?
                                  Image.memory(
                                    base64Decode(_teachers[x]["base64Image"]),
                                    width: 45,
                                    height: 45,
                                  ) :
                                  Image(
                                    image: NetworkImage("https://static.vecteezy.com/system/resources/thumbnails/035/857/779/small/people-face-avatar-icon-cartoon-character-png.png"),
                                    width: 45,
                                    height: 45,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(child: Center(child: Text('${_teachers[x]["fname"]} ${_teachers[x]["lname"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                            TableCell(child: Center(child: Text('${_teachers[x]["age"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                            TableCell(child: Center(child: Text('${_teachers[x]["teacher_id"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                            TableCell(child: Center(child: Text('${_teachers[x]["email"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                            TableCell(child: Center(child: Text('${_teachers[x]["phone"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                            TableCell(child: Center(child: Text('${_teachers[x]["gender"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                            TableCell(child: Center(child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                customButton: Icon(
                                    Icons.more_vert,
                                    color: colors.lightblue
                                ),
                                items: [
                                  ...MenuItems.firstItems.map(
                                        (item) => DropdownMenuItem<MenuItem>(
                                      value: item,
                                      child: MenuItems.buildItem(item),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  MenuItems.onChanged(context, value! as MenuItem);
                                  showDialog<void>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                                          ),
                                          content: value.text == "Edit" ?
                                          EditModal(details: _teachers[x],) :
                                          DeleteModal(details: _teachers[x],onDelete: (){
                                            _teacherApis.delete(teacher_id: _teachers[x]["teacher_id"]).whenComplete((){
                                              Navigator.of(context).pop(null);
                                            });
                                          },)
                                      )
                                  );
                                },
                                dropdownStyleData: DropdownStyleData(
                                  width: 160,
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  offset: const Offset(0, 8),
                                ),
                                menuItemStyleData: MenuItemStyleData(
                                  customHeights: [
                                    ...List<double>.filled(MenuItems.firstItems.length, 48),

                                  ],
                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                ),
                              ),
                            ))),
                          ],
                        ),
                      }
                    ],
                  ),
                ),
              ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(15),
              child: FloatingActionButton.extended(
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          content: CreateMeeting()
                      )
                  );
                },
                label: Text('Create meeting',style: TextStyle(fontFamily: "OpenSans", color: colors.blue, fontSize: 15),),
                icon: Icon(Icons.groups, color: colors.blue,),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
            ),
          );
        }
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [home, share];

  static const home = MenuItem(text: 'Edit', icon: Icons.edit);
  static const share = MenuItem(text: 'Delete', icon: Icons.delete);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: colors.blue, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: TextStyle(
              color: colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
      //Do something
        break;
      case MenuItems.share:
      //Do something
        break;
    }
  }
}