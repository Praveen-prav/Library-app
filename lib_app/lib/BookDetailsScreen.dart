// ignore_for_file: file_names
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/material.dart';
import 'BooksListScreen.dart';
// import 'ReadPdfScreen.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  void openPDF(String pdfUrl) async {
    // Generate a Google Drive URL for the PDF file
    final driveUrl =
        'https://drive.google.com/viewerng/viewer?embedded=true&url=$pdfUrl';

    if (await canLaunchUrlString(driveUrl)) {
      await launchUrlString(driveUrl);
    } else {
      throw 'Could not launch $driveUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black,),
        title: Text(book.name, style: const TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 227, 226, 226),

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
            color: Colors.white,
            elevation: 2,
      
            child: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                  'Author : ${book.author}\n\nLanguage : ${book.language}\n\nGenre : ${book.genre}\n\nDescription : ${book.description}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),]
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton(onPressed: () async{
              String pdfUrl = book.pdfPath;
                openPDF(pdfUrl);
          },
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero,),
          backgroundColor: Colors.lightBlue,
          child: const Text('Read Book'),),
        ],
      ),
    );
  }
}
