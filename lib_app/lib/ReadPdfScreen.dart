// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// class ReadPdfScreen extends StatelessWidget {
//   const ReadPdfScreen({super.key, required this.pdfUrl});

//   final String pdfUrl;

//   void openPDF(String pdfUrl) async {
//   // Generate a Google Drive URL for the PDF file
//   final driveUrl = 'https://drive.google.com/viewerng/viewer?embedded=true&url=$pdfUrl';

//     if (await canLaunchUrlString(driveUrl)) {
//       await launchUrlString(driveUrl);
//     } else {
//       throw 'Could not launch $driveUrl';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }
