import 'package:flutter/material.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;

class Materialbutton{
  Widget materialButton(String? text,void Function()? function,{bool isLogout = false,bool isWhiteBck = false, bool isvalidated = true,double spacing = 5,Color textColor = Colors.white, String icon = "", double radius = 1000, double fontsize = 16}){
    return MaterialButton(
      height: 60,
      color: isLogout ? colors.darkred : !isvalidated ? Colors.grey : isWhiteBck ? Colors.white : colors.blue,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           icon == "" ? Container() : Image(
              width: 25,
              image: AssetImage(icon),
            ),
            SizedBox(
              width: spacing,
            ),
            Text(text!,style: TextStyle(fontSize: fontsize,fontFamily: "AppFontStyle",color: textColor),textAlign: TextAlign.center,),
          ],
        ),
      ),
      onPressed: function,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}