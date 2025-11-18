import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ctb_attendance_monitoring/services/apis/teachers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../../../functions/loaders.dart';
import '../../../utils/palettes/app_colors.dart' hide Colors;
import '../../../utils/snackbars/snackbar_message.dart';
import '../../../widgets/button.dart';

class EditModal extends StatefulWidget {
  final bool isEdit;
  final Map details;
  EditModal({this.isEdit = true,required this.details});
  @override
  State<EditModal> createState() => _EditModalState();
}

class _EditModalState extends State<EditModal> {
  final TeacherApis _teacherApis = new TeacherApis();
  final Materialbutton _materialbutton = new Materialbutton();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _teacherid = TextEditingController();
  String _department = "";
  String _year = "";
  String _base64 = "";
  Uint8List? _pickedImageBytes;

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

  @override
  void initState() {
    // TODO: implement initState
    if(widget.isEdit){
      _name.text = widget.details["name"];
      _age.text = "${widget.details["age"]}";
      _teacherid.text = "${widget.details["teacher_id"]}";
      _department = widget.details["department"];
      _year = widget.details["year"];
      _base64 = widget.details["base64Image"];
      _pickedImageBytes = widget.details["base64Image"] != "" ? base64Decode(widget.details["base64Image"]) : null;
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _name.dispose();
    _age.dispose();
    _teacherid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 550,
      height: 750,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: CircleAvatar(
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
                              image: NetworkImage("https://static.vecteezy.com/system/resources/thumbnails/035/857/779/small/people-face-avatar-icon-cartoon-character-png.png"),
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
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _name,
                  style: TextStyle(fontFamily: "OpenSans"),
                  decoration: InputDecoration(
                    hintText: 'Fullname',
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
                  keyboardType: TextInputType.number,
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
                  controller: _teacherid,
                  style: TextStyle(fontFamily: "OpenSans"),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Teacher ID',
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
                Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.blue.withOpacity(0.1)),
                      borderRadius: BorderRadius.all(Radius.circular(1000)),
                    ),
                  ),
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    style: TextStyle(fontFamily: "OpenSans",fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    items: <String>[
                      'College of Arts and Science',
                      'College of Education',
                      'College of Nursing',
                      'College of Engineering'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                      );
                    }).toList(),
                    hint: Text(_department.isEmpty
                        ? 'Department'
                        : _department,style: TextStyle(fontFamily: "OpenSans",fontSize: 16),),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _department = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.blue.withOpacity(0.1)),
                      borderRadius: BorderRadius.all(Radius.circular(1000)),
                    ),
                  ),
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    style: TextStyle(fontFamily: "OpenSans",fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    items: <String>[
                      '1st year',
                      '2nd year',
                      '3rd year',
                      '4th year'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                      );
                    }).toList(),
                    hint: Text(_year.isEmpty
                        ? 'Year'
                        : _year,style: TextStyle(fontFamily: "OpenSans",fontSize: 16),),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _year = value;
                        });
                      }
                    },
                  ),
                ),
                Spacer(),
                _materialbutton.materialButton(widget.isEdit ? "Update" : "Submit", (){
                  if(_name.text.isEmpty || _age.text.isEmpty || _teacherid.text.isEmpty || _department == "" || _year == ""){
                    _snackbarMessage.snackbarMessage(context, message: "All fields are required.", is_error: true);
                  }else{
                    Map _payload = {
                      "name": _name.text,
                      "age": _age.text,
                      "teacher_id": _teacherid.text,
                      "department": _department,
                      "year": _year,
                      "base64Image": _base64,
                    };
                    _screenLoaders.functionLoader(context);
                    if(widget.isEdit){
                      _teacherApis.edit(old_teacher_id: widget.details["teacher_id"], payload: _payload).whenComplete((){
                        Navigator.of(context).pop(null);
                        Navigator.of(context).pop(null);
                        _snackbarMessage.snackbarMessage(context, message: "Edit teacher details updated successfully!");
                      });
                    }else{
                      _teacherApis.add(payload: _payload).whenComplete((){
                        Navigator.of(context).pop(null);
                        Navigator.of(context).pop(null);
                        _snackbarMessage.snackbarMessage(context, message: "New teacher successfully created!");
                      });
                    }
                  }
                }),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          Positioned(
            right: -40,
            top: -35,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: colors.blue,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
