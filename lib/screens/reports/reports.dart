import 'dart:convert';
import 'package:ctb_attendance_monitoring/models/reports.dart';
import 'package:ctb_attendance_monitoring/screens/reports/components/report_form.dart';
import 'package:ctb_attendance_monitoring/services/apis/reports.dart';
import 'package:flutter/material.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;
import '../../widgets/appbar.dart';
import '../../widgets/no_data_widget.dart';
import '../../widgets/shimmer_loader/table.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class Reports extends StatefulWidget {
  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final GlobalKey _printKey = GlobalKey();
  final ReportsApis _reportsApis = new ReportsApis();
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _reportsApis.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: reportsModel.subject,
        builder: (context, snapshot) {

          return Scaffold(
            appBar: AppBar(
                elevation: 1,
                shadowColor: Colors.grey.shade200,
                centerTitle: false,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                flexibleSpace: Appbar(title: "REPORTS", type: "reports", isPrintable: true, onPrint: ()async{
                  Uint8List img = await captureWidget();
                  Uint8List pdf = await generatePdf(img);
                  Printing.layoutPdf(onLayout: (_) => pdf);
                }, hasTabs: false, onchange: (text) {
                  List _res = reportsModel.valueSearch.where((s) => s["type"].toString().toLowerCase().contains(text.toLowerCase()) || s["content"].toString().toLowerCase().contains(text.toLowerCase())).toList();
                  reportsModel.update(data: _res);

                }, hasAddButton: false, onAdd: (){}, onTeacherTab: (v){},)
            ),
            backgroundColor: Colors.white,
            body: !snapshot.hasData ?
            TableLoader() :
            snapshot.data!.isEmpty ?
            NoDataWidget() :
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
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                      4: FlexColumnWidth(),
                      5: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                        children: <Widget>[
                          TableCell(child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                            child: Center(child: Text('ID',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold),)),
                          )),
                          TableCell(child: Center(child: Text('Report type',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          TableCell(child: Center(child: Text('Content',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          TableCell(child: Center(child: Text('Email address',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          TableCell(child: Center(child: Text('Created at',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
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
                            TableCell(child: Center(child: Text('${snapshot.data![x]["type"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                            TableCell(child: Center(child: Text('${snapshot.data![x]["content"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                            TableCell(child: Center(child: Text('${snapshot.data![x]["email"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                            TableCell(child: Center(child: Text('${snapshot.data![x]["created_at"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                          ],
                        ),
                      }
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(15),
              child: FloatingActionButton.extended(
                onPressed: () {
                  reportTypeHelper.update(data: "");
                  showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          content: ReportForm()
                      )
                  );
                },
                label: Text('Create report',style: TextStyle(fontFamily: "OpenSans", color: colors.blue, fontSize: 15),),
                icon: Icon(Icons.edit, color: colors.blue,),
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
