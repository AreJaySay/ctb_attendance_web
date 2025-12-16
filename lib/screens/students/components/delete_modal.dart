import 'package:ctb_attendance_monitoring/functions/loaders.dart';
import 'package:ctb_attendance_monitoring/services/apis/students.dart';
import 'package:ctb_attendance_monitoring/widgets/button.dart';
import 'package:flutter/material.dart';

class DeleteModal extends StatefulWidget {
  final Map details;
  DeleteModal({required this.details});
  @override
  State<DeleteModal> createState() => _DeleteModalState();
}

class _DeleteModalState extends State<DeleteModal> {
  final StudentApis _studentApis = new StudentApis();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final Materialbutton _materialbutton = new Materialbutton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 150,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text("Delete student?", style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600,fontSize: 16),),
          SizedBox(
            height: 5,
          ),
          Text("Are you sure you want to delete this student?", style: TextStyle(fontFamily: "OpenSans"),),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: _materialbutton.materialButton("Cancel", (){
                  Navigator.of(context).pop(null);
                }, isWhiteBck: false),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _materialbutton.materialButton("Delete", (){
                  _screenLoaders.functionLoader(context);
                  _studentApis.delete(school_id: widget.details["lrn"]).whenComplete((){
                    Navigator.of(context).pop(null);
                    Navigator.of(context).pop(null);
                  });
                }, textColor: Colors.red, isWhiteBck: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
