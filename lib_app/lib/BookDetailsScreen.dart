// ignore_for_file: file_names
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/material.dart';
import 'BooksListScreen.dart';
// import 'ReadPdfScreen.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;
  final bool bgColor;

  const BookDetailsScreen({super.key, required this.book, required this.bgColor});

  void openPDF(String pdfUrl) async {
    // Generate a Google Drive URL for the PDF file
    final driveUrl =
        'https://drive.google.com/viewerng/viewer?embedded=true&url=$pdfUrl';

    if (await canLaunchUrlString(driveUrl)) {
      // sleep(const Duration(seconds: 2));
      await launchUrlString(driveUrl);
    } else {
      throw 'Could not launch $driveUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:bgColor? const BackButton(
          color: Colors.white,
        ) : const BackButton(
          color: Colors.black,
        ),
        title: Text(
          book.name,
          style:bgColor? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black),
        ),
        backgroundColor: bgColor ? Colors.black : Colors.white,
      ),
      backgroundColor: bgColor ? Colors.black : Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Image.network(
            book.coverImagePath,
            alignment: Alignment.center,
            width: 400,
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            color: bgColor?const Color.fromARGB(255, 52, 51, 51): Colors.white,
            elevation: 2,
            child: SizedBox(
              height: 200,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Author : ${book.author}\n\nLanguage : ${book.language}\n\nGenre : ${book.genre}\n\nDescription : ${book.description}',
                      style: bgColor? const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white): const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.start,
                    ),
                  ]),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
            color: Colors.lightBlue),
            width: 50,
            child: TextButton(onPressed: () async {
                String pdfUrl = book.pdfPath;
                openPDF(pdfUrl);
              },
              child: const Text('Read Book', style: TextStyle(color: Colors.white)),),
          )
        ],
      ),
    );
  }
}
