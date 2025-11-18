import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

import '../../../utils/palettes/app_colors.dart' hide Colors;

class TableLoader extends StatefulWidget {
  @override
  State<TableLoader> createState() => _TableLoaderState();
}

class _TableLoaderState extends State<TableLoader> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      child: Table(
        border: TableBorder.all(color: colors.umber.withOpacity(0.1)),
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(150),
          1: FixedColumnWidth(150),
          2: FlexColumnWidth(),
          3: FixedColumnWidth(100),
          4: FlexColumnWidth(),
          5: FlexColumnWidth(),
          6: FixedColumnWidth(100),
          7: FixedColumnWidth(100),
          8: FixedColumnWidth(150),
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
              TableCell(child: Center(child: Text('School ID',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
              TableCell(child: Center(child: Text('Department',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
              TableCell(child: Center(child: Text('Year',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
              TableCell(child: Center(child: Text('Section',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
              TableCell(child: Center(child: Text('Action',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
            ],
          ),
          for(int x = 0; x < 10; x++)...{
            TableRow(
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              children: <Widget>[
                for(int x = 0; x < 9; x++)...{
                  TableCell(child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 10,horizontal: 20),
                    child: Center(child: FadeShimmer(
                      height: 20,
                      width: double.infinity,
                      radius: 10,
                      highlightColor: Color(0xffF9F9FB),
                      baseColor: Color(0xffE6E8EB),
                    )),
                  )),
                }
              ],
            ),
          }
        ],
      ),
    );
    // return FadeShimmer(
    //   height: widget.height,
    //   width: widget.width,
    //   radius: widget.radius,
    //   highlightColor: Color(0xffF9F9FB),
    //   baseColor: Color(0xffE6E8EB),
    // );
  }
}
