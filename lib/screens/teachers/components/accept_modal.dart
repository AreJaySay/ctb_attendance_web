import 'package:ctb_attendance_monitoring/functions/loaders.dart';
import 'package:ctb_attendance_monitoring/services/apis/students.dart';
import 'package:ctb_attendance_monitoring/widgets/button.dart';
import 'package:flutter/material.dart';

class AcceptModal extends StatefulWidget {
  final Map details;
  final Function() onAccept;
  AcceptModal({required this.details, required this.onAccept});
  @override
  State<AcceptModal> createState() => _AcceptModalState();
}

class _AcceptModalState extends State<AcceptModal> {
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
          Text("Accept request?", style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600,fontSize: 16),),
          SizedBox(
            height: 5,
          ),
          Text("Are you sure you want to accept this request?", style: TextStyle(fontFamily: "OpenSans"),),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: _materialbutton.materialButton("Cancel", (){
                  Navigator.of(context).pop(null);
                }, isWhiteBck: true, textColor: Colors.black),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _materialbutton.materialButton("Confirm", (){
                  widget.onAccept();
                }, textColor: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
