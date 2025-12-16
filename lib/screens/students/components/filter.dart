import 'dart:convert';

import 'package:ctb_attendance_monitoring/models/students.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/palettes/app_colors.dart' hide Colors;
import '../../../widgets/button.dart';

class Filter extends StatefulWidget {
  final Function(Map) onConfirm;
  const Filter({required this.onConfirm});
  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final Materialbutton _materialbutton = new Materialbutton();
  List? _filters;
  Map? _selected;
  bool _isSelectAll = false;
  bool _isLoading = true;

  Future<void> _loadJson() async {
    final String response = await rootBundle.loadString('assets/jsons/filter_student.json');
    final data = json.decode(response);
    setState(() {
      _filters = data;
    });
    print("FILTERS $data");
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadJson().whenComplete((){
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 350,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Add Filter",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600, fontSize: 15),),
                  Spacer(),
                  Checkbox(
                    activeColor: colors.blue,
                    value: _isSelectAll,
                    onChanged: (v){
                      setState(() {
                        _isSelectAll = !_isSelectAll;
                        _selected = null;
                        studentsModel.update(data: studentsModel.valueSearch);
                      });
                    },
                  ),
                  Text("Select All",style: TextStyle(fontFamily: "OpenSans",),),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.blue.withOpacity(0.1)),
                    borderRadius: BorderRadius.all(Radius.circular(1000)),
                  ),
                ),
                child: _isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ) :
                DropdownButton<Map>(
                  focusColor: Colors.white,
                  style: TextStyle(fontFamily: "OpenSans",fontSize: 16),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  items: <Map>[
                    for(int x = 0; x < _filters!.length; x++)...{
                      _filters![x],
                    },
                  ].map((Map value) {
                    return DropdownMenuItem<Map>(
                      value: value,
                      child: Text("Grade ${value["grade"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                    );
                  }).toList(),
                  hint: Text(_selected == null
                      ? 'Select grade'
                      : "Grade ${_selected!["grade"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 16, color: _selected == null ? Colors.grey : Colors.black),),
                  borderRadius: BorderRadius.circular(10),
                  underline: SizedBox(),
                  isExpanded: true,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selected = value;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              IgnorePointer(
                ignoring: _selected == null,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.blue.withOpacity(0.1)),
                      borderRadius: BorderRadius.all(Radius.circular(1000)),
                    ),
                  ),
                  child: _selected == null ?
                  SizedBox() :
                  DropdownButton<String>(
                    focusColor: Colors.white,
                    style: TextStyle(fontFamily: "OpenSans",fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    items: <String>[
                      if(_selected!["sections"].isNotEmpty)...{
                        for(int x = 0; x < _selected!["sections"]!.length; x++)...{
                          _selected!["sections"][x],
                        },
                      }
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                      );
                    }).toList(),
                    hint: Text(
                      _selected!["sections"].isEmpty ? "No section available" :
                      _selected!["selected_section"] == "" ? 'Select section'
                        : _selected!["selected_section"],style: TextStyle(fontFamily: "OpenSans",fontSize: 16, color: _selected!["selected_section"] == "" ? Colors.grey : Colors.black),),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    icon: _selected!["sections"].isEmpty ? SizedBox() : Icon(Icons.arrow_drop_down_sharp),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selected!["selected_section"] = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              Spacer(),
              _materialbutton.materialButton("Continue", (){
                if(_selected != null){
                  widget.onConfirm(_selected!);
                }
                Navigator.of(context).pop(_selected);
              }),
              SizedBox(
                height: 30,
              ),
            ],
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
