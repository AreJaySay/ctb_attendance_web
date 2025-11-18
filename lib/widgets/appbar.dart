import 'dart:async';
import 'package:ctb_attendance_monitoring/credentials/login.dart';
import 'package:ctb_attendance_monitoring/models/users.dart';
import 'package:ctb_attendance_monitoring/services/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;
import '../models/page_navigators.dart';
import 'button.dart';

class Appbar extends StatefulWidget {
  final String title;
  final bool hasAddButton;
  final ValueChanged<String> onchange;
  final Function onAdd;
  Appbar({required this.title, this.hasAddButton = true, required this.onchange, required this.onAdd});
  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  final Routes _routes = new Routes();
  final Materialbutton _materialbutton = new Materialbutton();
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
    return StreamBuilder(
      stream: usersModel.loggedUser,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(widget.title,style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: _selected == "book" ? colors.blue : Colors.grey,),),
              if(widget.hasAddButton)...{
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: SizedBox(
                    width: 23,
                    height: 23,
                    child: CircleAvatar(
                      backgroundColor: colors.blue,
                      child: Center(
                        child: Icon(Icons.add,color: Colors.white,size: 20,),
                      ),
                    ),
                  ),
                  onTap: (){
                    widget.onAdd();
                  },
                ),
              },
              Spacer(),
              IconButton(
                icon: Badge(
                  label: Text("3"),
                  child: Icon(Icons.notifications_active_outlined,size: 30,),
                ),
                onPressed: (){
                  pageNavigatorsModel.update(data: !pageNavigatorsModel.value);
                },
              ),
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
                      borderSide: BorderSide(color: colors.brown.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: colors.brown.withOpacity(0.4)),
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
              GestureDetector(
                onTap: (){
                  _showRightToLeftModal(context, user: snapshot.data!);
                },
                child: Center(
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/icons/type_admin.png"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        );
      }
    );
  }
  void _showRightToLeftModal(BuildContext context,{required Map user}) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Background color
      barrierDismissible: true, // Dismissible by tapping the barrier
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight, // Aligns the modal to the right
          child: Material(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
              color: Colors.white,
              width: 450,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        maxRadius: 30,
                        minRadius: 25,
                        backgroundColor: colors.lightblue.withOpacity(0.2),
                        backgroundImage: AssetImage("assets/icons/type_admin.png"),
                        foregroundColor: Colors.red,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${user["fname"]} ${user["lname"]}",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w600,fontSize: 15),),
                            SizedBox(
                              height: 5,
                            ),
                            Text("${user["type"]}",style: TextStyle(fontFamily: "OpenSans"),)
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(color: Colors.grey.shade200,),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: (){
                      print("asdasdwewe");
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text("Profile",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right)
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  _materialbutton.materialButton("Logout", ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    usersModel.updateUser(data: {});
                    _routes.navigator_pushreplacement(context, Login());
                  }, isLogout: true),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // This handles the slide animation
        return SlideTransition(
          // Tween begins at Offset(1, 0) (right side) and ends at Offset(0, 0) (original position)
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
