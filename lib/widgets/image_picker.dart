// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:ctb_attendance_monitoring/utils/palettes/app_colors.dart' hide Colors;
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:image_picker/image_picker.dart';
//
// class PickImage extends StatefulWidget {
//   final bool is_change;
//   final String image;
//   PickImage({this.is_change = false,this.image = ""});
//   @override
//   _PickImageState createState() => _PickImageState();
// }
//
// class _PickImageState extends State<PickImage> {
//   final ImagePicker _imagePicker = ImagePicker();
//
//
//   Future<File> _compress(File file) async {
//     print("NOT COMPRESSED ${file.lengthSync()}");
//     final Directory tempDir = await getTemporaryDirectory();
//     final targetPath = '${tempDir.path}/${path.basename(file.path)}_compressed.jpg';
//     var result = await FlutterImageCompress.compressAndGetFile(
//       file.absolute.path, targetPath,
//       quality: 88,
//       rotate: 0,
//     );
//     return File(result!.path);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 600,
//       height: widget.is_change ? 250 : 180,
//       padding: EdgeInsets.only(top: 30,left: 20,right: 20),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20)
//           )
//       ),
//       child: Column(
//         children: [
//           widget.is_change ? GestureDetector(
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: colors.umber)
//               ),
//               height: 55,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(Icons.image_rounded,color: colors.umber,size: 27,),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text("Voir la photo de profil",style: TextStyle(fontFamily: "OpenSans-medium",fontSize: 15.5,color: colors.umber,))
//                 ],
//               ),
//             ),
//             onTap: (){
//               showDialog(
//                 context: context,
//                 builder: (context) => Material(
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: NetworkImage(widget.image)
//                             )
//                         ),
//                       ),
//                       BackButton()
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ) : Container(),
//           SizedBox(
//             height:  widget.is_change ? 15 : 0,
//           ),
//           GestureDetector(
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   color: colors.umber,
//                   borderRadius: BorderRadius.circular(50)
//               ),
//               height: 55,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(Icons.camera_alt_outlined,color: Colors.white,),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text("Prendre une photo",style: TextStyle(fontFamily: "OpenSans-medium",color: Colors.white,fontSize: 15.5),)
//                 ],
//               ),
//             ),
//             onTap: ()async{
//               await _imagePicker.pickImage(source: ImageSource.camera,).then((value){
//                 Navigator.of(context).pop(File(value!.path));
//               });
//             },
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           GestureDetector(
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(color: colors.umber
//                   )
//               ),
//               height: 55,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(Icons.image_outlined,color: colors.umber,size: 27,),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text("Choisir depuis la galerie",style: TextStyle(fontFamily: "OpenSans-medium",fontSize: 15.5,color:  colors.umber,))
//                 ],
//               ),
//             ),
//             onTap: ()async{
//               await _imagePicker.pickImage(source: ImageSource.gallery,).then((value){
//                 _compress(File(value!.path)).then((compressed){
//                   print("COMPRESSED ${compressed.lengthSync()}");
//                   Navigator.of(context).pop(File(compressed!.path));
//                 });
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
