import 'dart:convert';
import 'dart:ui' as ui;
import 'package:ctb_attendance_monitoring/models/attendance.dart';
import 'package:ctb_attendance_monitoring/models/students.dart';
import 'package:ctb_attendance_monitoring/services/apis/attendance.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../services/routes.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;
import '../../widgets/appbar.dart';
import '../../widgets/shimmer_loader/table.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Attendance extends StatefulWidget {
  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final Routes _routes = new Routes();
  final AttendanceApis _attendanceApis = new AttendanceApis();
  final _scrollController = ScrollController();
  final GlobalKey _printKey = GlobalKey();
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
                automaticallyImplyLeading: false,
                flexibleSpace: Appbar(title: "ATTENDANCE", type: "attendances", isPrintable: true, onPrint: ()async{
                  Uint8List img = await captureWidget();
                  Uint8List pdf = await generatePdf(img);
                  Printing.layoutPdf(onLayout: (_) => pdf);
                }, onchange: (text) {
                  List _res = attendanceModel.valueSearch.where((s) => s["name"].toString().toLowerCase().contains(text.toLowerCase())).toList();
                  attendanceModel.update(data: _res);
                }, hasAddButton: false, onAdd: (){
                  _addTest();
                }, onTeacherTab: (v){}),
              ),
              backgroundColor: Colors.white,
              body: !snapshot.hasData ?
              TableLoader() :
              Stack(
                children: [
                  RepaintBoundary(
                    key: _printKey,
                    child: Scrollbar(
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
                                TableCell(child: Center(child: Text('LRN',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                TableCell(child: Center(child: Text('Age',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                TableCell(child: Center(child: Text('Year',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                TableCell(child: Center(child: Text('Section',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                TableCell(child: Center(child: Text('Time in',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                TableCell(child: Center(child: Text('Time out',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                              ],
                            ),
                            for(int x = 0; x < snapshot.data!.length; x++)...{
                              if(studentsModel.value.where((s) => s["unique_id"].toString() == snapshot.data![x].first["unique_id"].toString()).toList().isNotEmpty)...{
                                TableRow(
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                  ),
                                  children: <Widget>[
                                    TableCell(child: Padding(
                                      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                                      child: Center(child: Text('${x + 1}',style: TextStyle(fontFamily: "Roboto_normal"))),
                                    )),
                                    TableCell(child: Center(child: Text('${studentsModel.value.where((s) => s["unique_id"].toString() == snapshot.data![x].first["unique_id"].toString()).toList().first["name"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Center(child: Text('${studentsModel.value.where((s) => s["unique_id"] == snapshot.data![x].first["unique_id"]).toList().first["lrn"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Center(child: Text('${studentsModel.value.where((s) => s["unique_id"] == snapshot.data![x].first["unique_id"]).toList().first["age"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Center(child: Text('${studentsModel.value.where((s) => s["unique_id"] == snapshot.data![x].first["unique_id"]).toList().first["year"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Center(child: Text('${studentsModel.value.where((s) => s["unique_id"] == snapshot.data![x].first["unique_id"]).toList().first["section"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Center(child: Text('${DateFormat("dd MMM yyyy h:mm").format(DateTime.parse(snapshot.data![x].first["date_time"]))}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Center(child: Text('${DateFormat("dd MMM yyyy h:mm").format(DateTime.parse(snapshot.data![x].last["date_time"]))}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                  ],
                                ),
                              }

                            }
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          );
        }
    );
  }
  Future _addTest()async{
    FirebaseDatabase database = FirebaseDatabase.instance;

    DatabaseReference usersRef = database.ref('attendance');
    await usersRef.push().set({
      "name": "Juls Fernan Robert N. Mira",
      "lrn": "123416220009",
      "age": "14",
      "year": "Grade 4",
      "section": "Jupiter",
      "time_in": "${DateFormat("dd MMM yyyy h:mm a").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 33))}",
      "time_out": "${DateFormat("dd MMM yyyy h:mm a").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 15, 56))}",
    });
  }

  Future<Uint8List> captureWidget() async {
    RenderRepaintBoundary boundary =
    _printKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> generatePdf(Uint8List imageBytes) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);
    pdf.addPage(pw.Page(build: (ctx) => pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("ATTENDANCES"),
        pw.SizedBox(
          height: 20
        ),
        pw.Image(image)
      ]
    )));
    return pdf.save();
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