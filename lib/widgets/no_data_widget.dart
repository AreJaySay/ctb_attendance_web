import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            width: 110,
            height: 110,
            image: NetworkImage("https://static.thenounproject.com/png/4440902-200.png"),
            color: Colors.grey.shade400,
          ),
          SizedBox(
            height: 10,
          ),
          Text("NO DATA FOUND",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey.shade500,fontSize: 16),)
        ],
      ),
    );
  }
}
