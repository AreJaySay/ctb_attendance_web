import 'dart:convert';
import 'package:ctb_attendance_monitoring/models/attendance.dart';
import 'package:ctb_attendance_monitoring/services/apis/attendance.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../services/routes.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;
import '../../widgets/appbar.dart';
import '../../widgets/shimmer_loader/table.dart';

class Attendance extends StatefulWidget {
  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final Routes _routes = new Routes();
  final AttendanceApis _attendanceApis = new AttendanceApis();
  final _scrollController = ScrollController();
  List? _toSearch;

  @override
  void initState() {
    // TODO: implement initState
    _attendanceApis.getAttendances();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: attendanceModel.subject,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                elevation: 1,
                shadowColor: Colors.grey.shade200,
                centerTitle: false,
                backgroundColor: Colors.white,
                flexibleSpace: Appbar(title: "ATTENDANCE", onchange: (text) {
                  setState(() {
                    // _Attendance = _toSearch!.where((s) => s["name"].toString().toLowerCase().contains(text.toLowerCase())).toList();
                  });
                }, hasAddButton: false, onAdd: (){}),
              ),
              backgroundColor: Colors.white,
              body: !snapshot.hasData ?
              TableLoader() :
              Stack(
                children: [
                  Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      child: Table(
                        border: TableBorder.all(color: colors.blue.withOpacity(0.1)),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FixedColumnWidth(150),
                          1: FixedColumnWidth(250),
                          2: FlexColumnWidth(),
                          3: FlexColumnWidth(),
                          4: FlexColumnWidth(),
                          5: FlexColumnWidth(),
                          6: FlexColumnWidth(),
                          7: FlexColumnWidth(),
                          8: FlexColumnWidth(),
                        },
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(
                            children: <Widget>[
                              TableCell(child: Padding(
                                padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                                child: Center(child: Text('ID',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold),)),
                              )),
                              TableCell(child: Center(child: Text('Name',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                              TableCell(child: Center(child: Text('School ID',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                              TableCell(child: Center(child: Text('Department',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                              TableCell(child: Center(child: Text('Year',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                              TableCell(child: Center(child: Text('Section',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                              TableCell(child: Center(child: Text('Time in',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                              TableCell(child: Center(child: Text('Time out',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                              TableCell(child: Center(child: Text('Action',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                            ],
                          ),
                          for(int x = 0; x < snapshot.data!.length; x++)...{
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                              children: <Widget>[
                                TableCell(child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                                  child: Center(child: Text('${x + 1}',style: TextStyle(fontFamily: "Roboto_normal"))),
                                )),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["name"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["school_id"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["department"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["year"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["time_in"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["time_out"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["section"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
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
                ],
              )
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