import 'dart:convert';
import 'package:ctb_attendance_monitoring/models/teachers.dart';
import 'package:ctb_attendance_monitoring/services/apis/teachers.dart';
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
  final _scrollController = ScrollController();
  List? _toSearch;

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
          return Scaffold(
              appBar: AppBar(
                elevation: 1,
                shadowColor: Colors.grey.shade200,
                centerTitle: false,
                backgroundColor: Colors.white,
                flexibleSpace: Appbar(title: "TEACHERS", onchange: (text) {
                  setState(() {
                    // _Teachers = _toSearch!.where((s) => s["name"].toString().toLowerCase().contains(text.toLowerCase())).toList();
                  });
                }, onAdd: (){
                  showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          content: EditModal(isEdit: false,details: {})
                      )
                  );
                }),
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
                          1: FixedColumnWidth(150),
                          2: FixedColumnWidth(250),
                          3: FlexColumnWidth(),
                          4: FlexColumnWidth(),
                          5: FlexColumnWidth(),
                          6: FixedColumnWidth(100),
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
                              TableCell(child: Center(child: Text('Department',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                              TableCell(child: Center(child: Text('Year',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
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
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: InkWell(
                                      onTap: (){
                                        print("asdasdasd"+snapshot.data![x]["base64Image"]);
                                      },
                                      child: Center(
                                        child: snapshot.data![x]["base64Image"] != "" ?
                                        Image.memory(
                                          base64Decode(snapshot.data![x]["base64Image"]),
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
                                ),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["name"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["age"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["teacher_id"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["department"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x]["year"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
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
                                              content: value.text == "Edit" ? EditModal(details: snapshot.data![x],) : DeleteModal(details: snapshot.data![x],)
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