import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../models/game.dart';

class Detail extends StatefulWidget {
  final int gameId;

  const Detail({super.key, required this.gameId});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Map<String, dynamic> game = {};
  bool isLoading = true;
  bool isOwned = false;
  String email = '';

  bool _checkOwned() {
    final box = Hive.box<Game>('library');
    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i)!;
      if (item.id == widget.gameId && item.email == email) {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameData = await ApiService.getGameDetail(widget.gameId);
      if (!mounted) return;
      setState(() {
        email = prefs.getString('email') ?? '';
        game = gameData;
        isOwned = _checkOwned();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _getGame() {
    final box = Hive.box<Game>('library');
    box.add(
      Game(
        id: game['id'],
        title: game['title'],
        thumbnail: game['thumbnail'],
        genre: game['genre'],
        platform: game['platform'],
        email: email,
      ),
    );

    setState(() {
      isOwned = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${game['title']} ditambahkan ke Library')),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchGame();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> screenshots = game['screenshots'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : game.isEmpty
              ? Center(child: Text('Gagal memuat data'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        game['thumbnail'],
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    game['genre'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Text(
                                  game['platform'],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              game['title'],
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Release Date',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        game['release_date'],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Publisher',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        game['publisher'],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Developer',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        game['developer'],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: isOwned ? null : _getGame,
                                icon: Icon(isOwned ? Icons.check : Icons.add),
                                label: Text(isOwned ? 'In Library' : 'Get'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.all(14),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Screenshots',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 90,
                              child: ListView.separated(
                                itemCount: screenshots.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    screenshots[index]['image'],
                                    width: 150,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 8),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Overview',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              game['description'] ?? 'Tidak ada deskripsi.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}