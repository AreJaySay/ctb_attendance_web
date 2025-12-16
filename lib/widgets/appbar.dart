import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:ctb_attendance_monitoring/credentials/login.dart';
import 'package:ctb_attendance_monitoring/models/admin.dart';
import 'package:ctb_attendance_monitoring/services/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;
import '../models/notifications.dart';
import '../models/page_navigators.dart';
import '../models/user.dart';
import '../screens/announcements/announcements.dart';
import 'button.dart';

class Appbar extends StatefulWidget {
  final String title, type, hint, pendingCount;
  final Widget? filterWidget;
  final bool hasAddButton, hasTabs, isPrintable;
  final ValueChanged<String> onchange;
  final Function onAdd, onPrint;
  final Function(bool) onTeacherTab;
  Appbar({required this.title, required this.type, this.hint = "Search...", this.pendingCount = "0", this.filterWidget, this.hasAddButton = true, this.hasTabs = false, this.isPrintable = false, required this.onchange, required this.onAdd, required this.onPrint, required this.onTeacherTab});
  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  final TextEditingController _fname = new TextEditingController();
  final TextEditingController _lname = new TextEditingController();
  final TextEditingController _age = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _phone = new TextEditingController();
  String _gender = "";
  final Routes _routes = new Routes();
  final Materialbutton _materialbutton = new Materialbutton();
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  String _selectedTab = "";
  Uint8List? _pickedImageBytes;
  String _base64 = "";

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
    _fname.text = userModel.loggedUser.value["fname"];
    _lname.text = userModel.loggedUser.value["lname"];
    _age.text = userModel.loggedUser.value["age"];
    _email.text = userModel.loggedUser.value["email"];
    _phone.text = userModel.loggedUser.value["phone"];
    _gender = userModel.loggedUser.value["gender"];
    _pickedImageBytes = userModel.loggedUser.value["base64Image"] != "" ? base64Decode(userModel.loggedUser.value["base64Image"]) : null;
    _selectedTab = widget.type;
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
      stream: userModel.loggedUser,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              InkWell(
                splashColor: Colors.white,
                onTap: !widget.hasTabs ? null : (){
                  if(widget.hasTabs){
                    setState(() {
                      _selectedTab = widget.type;
                    });
                    widget.onTeacherTab(true);
                  }
                },
                child: Container(
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Center(child: Text(widget.title,style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: _selectedTab == widget.type ? colors.blue : Colors.grey,),),),
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
                      ],
                    )),
              ),
              if(widget.hasTabs)...{
                VerticalDivider(),
                Container(
                  width: 100,
                  height: 55,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        _selectedTab = "pending";
                      });
                      widget.onTeacherTab(false);
                    },
                    child: Center(
                      child: Badge(
                        isLabelVisible: _selectedTab != "pending",
                        label: Text(widget.pendingCount),
                        offset: Offset(15, -10),
                        child: Text("PENDING",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: _selectedTab == "pending" ? colors.blue : Colors.grey,),),
                      ),
                    ),
                  ),
                )
              },
              SizedBox(
                width: 50,
              ),
              Spacer(),
              if(widget.isPrintable)...{
                IconButton(
                  icon: Icon(Icons.print, size: 27, color: colors.blue,),
                  onPressed: (){
                    widget.onPrint();
                  },
                ),
                SizedBox(
                  width: 15,
                )
              },
              Visibility(
                visible: widget.type != "announcements",
                child: IconButton(
                  icon: Image(
                    color:  colors.blue,
                    image: AssetImage("assets/icons/announcement.png"),
                  ),
                  onPressed: (){
                    pageNavigatorsModel.update(data: "announcements");
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              StreamBuilder(
                  stream: notificationModel.subject,
                  builder: (context, snapshot) {
                    return IconButton(
                      icon: Badge(child: Icon(Icons.notifications_none, color: colors.blue,), label: Text("${!snapshot.hasData ? "0" : snapshot.data!.where((s) => s["is_read"] == "0").toList().length}"),),
                      onPressed: (){
                        pageNavigatorsModel.update(data: "notifications");
                      },
                    );
                  }
              ),
              SizedBox(
                width: 15,
              ),
              widget.filterWidget ?? SizedBox(),
              SizedBox(
                width: 15,
              ),
              SizedBox(
                width: widget.type != "announcements" ? 350 : 400,
                child: TextField(
                  style: TextStyle(fontFamily: "OpenSans"),
                  decoration: InputDecoration(
                    hintText: widget.hint,
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
                      backgroundImage: NetworkImage("https://cdn-icons-png.freepik.com/512/8742/8742495.png"),
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
              padding: EdgeInsets.symmetric(horizontal: 25,vertical: 30),
              color: Colors.white,
              width: 450,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      minRadius: 45,
                      maxRadius: 65,
                      child: Stack(
                        children: [
                          Center(
                            child: _pickedImageBytes != null ?
                            Image.memory(
                              _pickedImageBytes!,
                              fit: BoxFit.fill,
                            ) : Image(
                              image: NetworkImage("https://cdn-icons-png.freepik.com/512/8742/8742495.png"),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async{
                                  _convertBase64();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  child: Icon(Icons.edit,color: colors.blue,),
                                ),
                              )
                          ),
                        ],
                      )
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _fname,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: 'Firstname',
                      hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.blue.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.blue.withOpacity(0.4)),
                      ),
                    ),
                    onChanged: (text) {

                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _lname,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: 'Lastname',
                      hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.blue.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.blue.withOpacity(0.4)),
                      ),
                    ),
                    onChanged: (text) {

                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _age,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: 'Age',
                      hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.blue.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.blue.withOpacity(0.4)),
                      ),
                    ),
                    onChanged: (text) {

                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _email,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: 'Email address',
                      hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.blue.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.blue.withOpacity(0.4)),
                      ),
                    ),
                    onChanged: (text) {

                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _phone,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.blue.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.blue.withOpacity(0.4)),
                      ),
                    ),
                    onChanged: (text) {

                    },
                  ),
                  Spacer(),
                  _materialbutton.materialButton("Update", ()async{
                    print(userModel.loggedUser.value);
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    child: Center(child: Text("Logout",style: TextStyle(color: colors.darkred, fontWeight: FontWeight.w700),)),
                    onPressed: ()async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      userModel.updateUser(data: {});
                      _routes.navigator_pushreplacement(context, Login());
                    },
                  ),
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
  Future<String?> _convertBase64() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        setState(() {
          _base64 = base64Encode(fileBytes);
          _pickedImageBytes = result.files.first.bytes;
          print("GET IMAGE BYTE $_pickedImageBytes");
        });
      }
    }
    return null;
  }
}
