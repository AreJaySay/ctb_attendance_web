import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/palettes/app_colors.dart' hide Colors;

class ScreenLoaders{
  void functionLoader(context){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.2),
              child: Center(
                child: CircularProgressIndicator(color: colors.brown,)
              ),
            ),
          );
        },
      );
  }
}