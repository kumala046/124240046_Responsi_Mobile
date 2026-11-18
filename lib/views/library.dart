import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game.dart';
import 'detail.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  void _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      email = prefs.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Anda', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Game>('library').listenable(),
        builder: (context, box, child) {
          final myGames = box.values.where((game) => game.email == email).toList();

          if (myGames.isEmpty) {
            return Center(child: Text('Library masih kosong'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: myGames.length,
            itemBuilder: (context, index) {
              final game = myGames[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detail(gameId: game.id),
                    ),
                  );
                },
                child: Card(
                  color: Colors.grey[900],
                  child: Row(
                    children: [
                      Image.network(
                        game.thumbnail,
                        width: 110,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  game.genre,
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                game.platform,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          game.delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}