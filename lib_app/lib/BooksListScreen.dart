// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'BookDetailsScreen.dart';

class Book {
  final String name;
  final String author;
  final String description;
  final String coverImagePath;
  final String pdfPath;
  final String language;
  final String genre;

  Book({
    required this.name,
    required this.author,
    required this.description,
    required this.coverImagePath,
    required this.pdfPath,
    required this.language,
    required this.genre,
  });
}

class BooksListScreen extends StatefulWidget {
  const BooksListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BooksListScreenState createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  String? selectedLanguage = 'All';

  List<String> genreOptions = [
    'Fiction',
    'Non Fiction',
    // Add more genre options as needed
  ];
  String selectedGenre = 'All';

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  void fetchBooks() async {
    // Disable certificate verification
    HttpOverrides.global = MyHttpOverrides();

    final response =
        await http.get(Uri.parse('https://library-backend-serv.onrender.com//books'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        books = data.map((bookData) {
          return Book(
              name: bookData['name'],
              author: bookData['author'],
              description: bookData['description'],
              coverImagePath:
                  bookData['cover_image_path'].replaceAll('/books', ''),
              pdfPath: bookData['pdf_path'].replaceAll('/books', ''),
              language: bookData['language'],
              genre: bookData['genre']);
        }).toList();
        filteredBooks = books; // Initialize filteredBooks with all books
      });
    } else {
      throw Exception('Failed to fetch books');
    }
  }

  void searchBooks(String query) {
    setState(() {
      filteredBooks = books
          .where((book) =>
              (book.language == selectedLanguage ||
                  selectedLanguage == 'All') &&
              (book.name.toLowerCase().contains(query.toLowerCase()) ||
                  book.author.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  void filterBooksByLanguage(String? language) {
    setState(() {
      selectedLanguage = language;
      if (language == 'All') {
        filteredBooks = books;
      } else {
        filteredBooks =
            books.where((book) => book.language == language).toList();
      }
    });
  }

  void filterBooksByGenre(String? genre) {
    setState(() {
      selectedGenre = genre ?? 'All';
      if (selectedGenre == 'All') {
        filteredBooks = books;
      } else {
        filteredBooks =
            books.where((book) => book.genre == selectedGenre).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
              color: Colors.black,
            );
          },
        ),
        actions: [
          // Language filter dropdown menu
          DropdownButton<String>(
            value: selectedLanguage,
            items: const [
              DropdownMenuItem(
                value: 'All',
                child: Text('All Languages'),
              ),
              DropdownMenuItem(
                value: 'English',
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: 'Hindi',
                child: Text('Hindi'),
              ),
              DropdownMenuItem(
                value: 'Telugu',
                child: Text('Telugu'),
              ),
              DropdownMenuItem(
                value: 'Tamil',
                child: Text('Tamil'),
              ),
              // Add more language options here
            ],
            onChanged: filterBooksByLanguage,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 14, 39, 59)),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('Categories'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Contacts'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: searchBooks,
              decoration: const InputDecoration(
                labelText: 'Search by title or author',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Book list
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookDetailsScreen(book: filteredBooks[index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Book cover image
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  filteredBooks[index].coverImagePath,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Book title
                              Text(
                                filteredBooks[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Book author
                              Text(
                                'By ${filteredBooks[index].author}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
