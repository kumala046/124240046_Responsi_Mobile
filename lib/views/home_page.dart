import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> games = [];
  bool isLoading = true;

  Future<void> fetchGames() async {
    try {
      final gameData = await ApiService.getGames();
      if (!mounted) return;
      setState(() {
        games = gameData;
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

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Games', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detail(gameId: game['id']),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey[900],
                    clipBehavior: Clip.antiAlias,
                    child: Row(
                      children: [
                        Image.network(
                          game['thumbnail'],
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
                                  game['title'],
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
                                    game['genre'],
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  game['platform'],
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
                        Icon(Icons.chevron_right, color: Colors.grey),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}