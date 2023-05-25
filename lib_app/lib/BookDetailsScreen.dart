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
        title: Text(book.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              book.coverImagePath,
              width: 300,
              height: 600,
            ),
            const SizedBox(height: 16),
            Text(
              'Author: ${book.author}\n\nDescription: ${book.description}',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String fileName = book.pdfPath.replaceAll(
                    'https://192.168.29.19:51000/static/assets/pdfs/', '');
                print(fileName);
                String pdfUrl =
                    'https://praveen-prav.github.io/backend_lib/static/assets/pdfs/$fileName';
                openPDF(pdfUrl);
              },
              child: const Text('Open PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
