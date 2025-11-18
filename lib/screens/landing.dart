import 'package:ctb_attendance_monitoring/screens/attendance/attendance.dart';
import 'package:ctb_attendance_monitoring/screens/reports/reports.dart';
import 'package:ctb_attendance_monitoring/screens/students/students.dart';
import 'package:ctb_attendance_monitoring/screens/teachers/teachers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:ctb_attendance_monitoring/utils/palettes/app_colors.dart' hide Colors;

import '../models/page_navigators.dart';
import 'notifications.dart';

class Landing extends StatefulWidget {
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final SideMenuController _sideMenuController = SideMenuController();
  List<String> _title = ["Students", "Teachers", "Attendance", "Reports"];
  List<String> _icons = ["student", "teacher", "attendance", "reports"];
  List<Widget> _pages = [Students(), Teachers(), Attendance(), Reports()];
  int _selected = 0;
  bool _isCollapsed = false;

  @override
  void initState() {
    // TODO: implement initState
    pageNavigatorsModel.update(data: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SideMenu(
            maxWidth: 300,
            minWidth: 110,
            hasResizer: false,
            backgroundColor: Colors.white,
            controller: _sideMenuController,
            builder: (data) => SideMenuData(
              header: Padding(
                padding: EdgeInsets.only(left: 35, right: 20, top: 20,bottom: 30),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/logos/main_logo.png"),
                    ),
                    if(!_isCollapsed)...{
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "CATBALOGAN V",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,fontFamily: "OpenSans",color: colors.blue),
                            children: <TextSpan>[
                              TextSpan(text: ' ATTENDANCE MONITORING SYSTEM', style: TextStyle(fontSize: 14,fontFamily: "OpenSans",fontWeight: FontWeight.w400, color: colors.blue)),
                            ],
                          ),
                        ),
                      ),
                    }
                  ],
                ),
              ),
              items: [
                for(int x = 0; x < _title.length; x++)...{
                  SideMenuItemDataTile(
                    isSelected: _selected == x,
                    onTap: () {
                      setState(() {
                        _selected = x;
                      });
                      pageNavigatorsModel.update(data: false);
                    },
                    title: _title[x],
                    icon: Center(
                      child: Image(
                        width: x == 2 || x == 3 ? 25 : 30,
                        height: x == 2 || x == 3 ? 25 : 30,
                        color: _selected == x ? Colors.white : colors.grey,
                        image: AssetImage("assets/icons/${_icons[x]}.png"),
                      ),
                    ),
                    titleStyle: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.w500),
                    selectedTitleStyle: TextStyle(color: Colors.white),
                    itemHeight: 55,
                    borderRadius: BorderRadiusGeometry.circular(10),
                    hasSelectedLine: false,
                    highlightSelectedColor: colors.blue,
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 3)
                  ),
                }
              ],
              footer: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: FloatingActionButton(
                  backgroundColor: colors.blue,
                  shape: const CircleBorder(),
                  child: _isCollapsed ? Icon(Icons.keyboard_arrow_right,color: Colors.white,size: 30,) : Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 30,),
                  onPressed: (){
                    setState(() {
                      _sideMenuController!.toggle();
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              )
            ),
            hasResizerToggle: false,
          ),
          StreamBuilder(
            stream: pageNavigatorsModel.subject,
            builder: (context, snapshot) {
              return Expanded(
                child: snapshot.data! ?
                Notifications() :
                _pages[_selected],
              );
            }
          )
        ],
      ),
      drawerEnableOpenDragGesture: false,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'End Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Handle item tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Handle item tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
