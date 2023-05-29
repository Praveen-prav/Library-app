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
  late bool _backgroundColor;
  // int DarkTextColor = Colors.black as int;
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
    _backgroundColor = false;
  }

  void fetchBooks() async {
    // Disable certificate verification
    HttpOverrides.global = MyHttpOverrides();

    final response = await http
        .get(Uri.parse('https://library-backend-serv.onrender.com//books'));
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
        title: TextField(
          onChanged: searchBooks,
          style: _backgroundColor ? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black),
          decoration:
          _backgroundColor ? const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by Title or Author',
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(Icons.search, color: Colors.white,),
          ) : const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by Title or Author',
            hintStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(Icons.search, color: Colors.black),
          )
        ),
        backgroundColor: _backgroundColor ? Colors.black : Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
              color: _backgroundColor ? Colors.white : Colors.black,
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: _backgroundColor? const Color.fromARGB(255, 52, 51, 51) : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 14, 39, 59)),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              title: Text('Categories', style: _backgroundColor? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context, 'ok');
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: _backgroundColor? const Color.fromARGB(255, 52, 51, 51) : Colors.white,
                        scrollable: true,
                        title: _backgroundColor? const Text('Select genre',style: TextStyle(color: Colors.white),) : const Text('Select genre',style: TextStyle(color: Colors.black),),
                        content: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.lightBlue,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    selectedGenre = 'All';
                                    filterBooksByGenre(selectedGenre);
                                  },
                                  child: const Text(
                                    'All',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.lightBlue,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    selectedGenre = 'Fiction';
                                    filterBooksByGenre(selectedGenre);
                                  },
                                  child: const Text(
                                    'Fiction',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.lightBlue,
                                ),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      selectedGenre = 'Non Fiction';
                                      filterBooksByGenre(selectedGenre);
                                    },
                                    child: const Text(
                                      'Non Fiction',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
            _backgroundColor? const Divider(thickness : 1, color: Colors.white, height: 0.5,): const Divider(thickness : 1, color: Colors.black, height: 0.5,),
            //..............................................................................................
            ListTile(
              title: Text('Language', style: _backgroundColor? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context, 'ok');
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: _backgroundColor? const Color.fromARGB(255, 52, 51, 51) : Colors.white,
                        scrollable: true,
                        title: _backgroundColor? const Text('Select Language', style: TextStyle(color: Colors.white),) : const Text('Select Language', style: TextStyle(color: Colors.black),),
                        content: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.lightBlue,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    selectedLanguage = 'All';
                                    filterBooksByLanguage(selectedLanguage);
                                  },
                                  child: const Text(
                                    'All',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.lightBlue,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    selectedLanguage = 'English';
                                    filterBooksByLanguage(selectedLanguage);
                                  },
                                  child: const Text(
                                    'English',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.lightBlue,
                                ),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      selectedLanguage = 'Telugu';
                                      filterBooksByLanguage(selectedLanguage);
                                    },
                                    child: const Text(
                                      'Telugu',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.lightBlue,
                                ),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      selectedLanguage = 'Tamil';
                                      filterBooksByLanguage(selectedLanguage);
                                    },
                                    child: const Text(
                                      'Tamil',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.lightBlue,
                                ),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      selectedLanguage = 'Hindi';
                                      filterBooksByLanguage(selectedLanguage);
                                    },
                                    child: const Text(
                                      'Hindi',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
            _backgroundColor? const Divider(thickness : 1, color: Colors.white, height: 0.5,): const Divider(thickness : 1, color: Colors.black, height: 0.5,),
            //........................................................................................................................
            ListTile(
              title: Text('Dark mode', style: _backgroundColor? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: _backgroundColor? const Color.fromARGB(255, 52, 51, 51) : Colors.white,
                        content: Row(
                          children: [
                            _backgroundColor? const Text('Enable Dark mode', style: TextStyle(color: Colors.white),) : const Text('Enable Dark mode', style: TextStyle(color: Colors.black),),
                            Switch(
                                activeColor: Colors.lightBlue,
                                activeTrackColor: const Color.fromARGB(255, 231, 233, 234),
                                inactiveThumbColor: Colors.blueGrey.shade600,
                                inactiveTrackColor: Colors.grey.shade400,
                                splashRadius: 50.0,
                                value: _backgroundColor,
                                onChanged: (value) => setState(() {
                                      Navigator.pop(context);
                                      _backgroundColor = value;
                                    }))
                          ],
                        ),
                      );
                    });
              },
            ),
            _backgroundColor? const Divider(thickness : 1, color: Colors.white, height: 0.5,): const Divider(thickness : 1, color: Colors.black, height: 0.5,),
            ListTile(
              title: Text('Contact', style: _backgroundColor? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _backgroundColor? const Divider(thickness : 1, color: Colors.white, height: 0.5,): const Divider(thickness : 1, color: Colors.black, height: 0.5,),
          ],
        ),
      ),
      body: Container(
        color: _backgroundColor ? Colors.black : Colors.white,
        child: Column(
          children: [
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
                          builder: (context) => BookDetailsScreen(
                              book: filteredBooks[index],
                              bgColor: _backgroundColor),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      color: _backgroundColor
                          ? const Color.fromARGB(255, 52, 51, 51)
                          : Colors.white,
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

                                _backgroundColor ? 
                                // Book title
                                Text(
                                  filteredBooks[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ) : Text(
                                  filteredBooks[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
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
