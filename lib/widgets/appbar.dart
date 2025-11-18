import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;

class Appbar extends StatefulWidget {
  final String title;
  final bool isBook, isReservation, hasAddButton;
  final ValueChanged<String> onchange;
  final Function(String)? selected;
  final Function onAdd;
  Appbar({required this.title, required this.onchange, this.isBook = false, this.isReservation = false, this.hasAddButton = false, this.selected, required this.onAdd});
  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  String _selected = "book";

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.jms().format(_currentTime);
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            // if(pageNavigatorsModel.value)...{
            //   Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 10),
            //     child: Row(
            //       children: [
            //         IconButton(
            //           icon: Icon(Icons.arrow_back),
            //           onPressed: (){
            //             pageNavigatorsModel.update(data: false);
            //           },
            //         ),
            //         SizedBox(
            //           width: 30,
            //         ),
            //         Text("NOTIFICATIONS",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: colors.umber),),
            //       ],
            //     ),
            //   ),
            // }else...{
            //   IgnorePointer(
            //     ignoring: !widget.isBook,
            //     child: InkWell(
            //         onTap: (){
            //           widget.selected!("book");
            //           setState(() {
            //             _selected = "book";
            //           });
            //         },
            //         child: Container(
            //           height: 50,
            //           padding: EdgeInsets.symmetric(horizontal: 20),
            //           child: Row(
            //             children: [
            //               Text(widget.title,style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: _selected == "book" ? colors.umber : Colors.grey,),),
            //               if(widget.isBook || widget.hasAddButton)...{
            //                 SizedBox(
            //                   width: 10,
            //                 ),
            //                 GestureDetector(
            //                   child: SizedBox(
            //                     width: 23,
            //                     height: 23,
            //                     child: CircleAvatar(
            //                       backgroundColor: _selected == "book" ? colors.umber : Colors.grey,
            //                       child: Center(
            //                         child: Icon(Icons.add,color: Colors.white,size: 20,),
            //                       ),
            //                     ),
            //                   ),
            //                   onTap: (){
            //                     widget.onAdd();
            //                   },
            //                 )
            //               },
            //             ],
            //           ),
            //         )
            //     ),
            //   ),
            //   if(widget.isBook)...{
            //     VerticalDivider(color: colors.umber.withOpacity(0.1),),
            //   },
            //   if(widget.isBook)...{
            //     InkWell(
            //         onTap: (){
            //           widget.selected!("borrower");
            //           setState(() {
            //             _selected = "borrower";
            //           });
            //         },
            //         child: Container(
            //           height: 50,
            //           padding: EdgeInsets.symmetric(horizontal: 20),
            //           child: Center(child: Text("BORROWERS",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: _selected == "borrower" ? colors.umber : Colors.grey,),)),
            //         )
            //     ),
            //   },
            //   if(widget.isReservation)...{
            //     VerticalDivider(color: colors.umber.withOpacity(0.1),),
            //   },
            //   if(widget.isReservation)...{
            //     InkWell(
            //         onTap: (){
            //           widget.selected!("reservation");
            //           setState(() {
            //             _selected = "reservation";
            //           });
            //         },
            //         child: Container(
            //           height: 50,
            //           padding: EdgeInsets.symmetric(horizontal: 20),
            //           child: Center(child: Text("RESERVATIONS",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: _selected == "reservation" ? colors.umber : Colors.grey,),)),
            //         )
            //     ),
            //   },
            // },
            // Spacer(),
            // IconButton(
            //   icon: Badge(
            //     label: Text("3"),
            //     child: Icon(Icons.notifications_active_outlined,size: 30,),
            //   ),
            //   onPressed: (){
            //     pageNavigatorsModel.update(data: !pageNavigatorsModel.value);
            //   },
            // ),
            SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                style: TextStyle(fontFamily: "OpenSans"),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  hintStyle: TextStyle(fontFamily: "OpenSans"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1000),
                    borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1000),
                    borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                  ),
                ),
                onChanged: (text) {
                  widget.onchange(text);
                },
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(formattedTime,style: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.bold),),
                Text(DateFormat("MMM dd, yyyy").format(DateTime.now()),style: TextStyle(fontFamily: "OpenSans",fontSize: 11),),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Center(
              child: SizedBox(
                height: 35,
                width: 35,
                child: CircleAvatar(
                  backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/9193/9193832.png"),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
