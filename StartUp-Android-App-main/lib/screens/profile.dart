import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'event_all_in_one.dart';
import 'book_event.dart';
import 'booking_history.dart';
// For ChatBotPage

class ProfilePage extends StatefulWidget {
  final String userEmail;

  const ProfilePage({super.key, required this.userEmail});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 1;

  /// 🔹 Logout function in app bar only
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  /// 🔹 Navigation handler
  void _onNavTapped(int index) {
    Widget page;

    switch (index) {
      case 0:
        page = EventAllInOnePage(userEmail: widget.userEmail);
        break;
      case 1:
        page = ProfilePage(userEmail: widget.userEmail);
        break;
      case 2:
        page = BookEventPage(userEmail: widget.userEmail);
        break;
      case 3:
        page = BookingHistoryPage(userEmail: widget.userEmail);
        break;
      default:
        page = ProfilePage(userEmail: widget.userEmail);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // 🔹 Sample funky messages and images
  final List<Map<String, String>> funkyItems = [
    {"msg": "🎉 Thank you for joining!", "img": "assets/images/caterer.png"},
    {"msg": "🤩 You rock!", "img": "assets/images/decorator.png"},
    {"msg": "🎈 Let's party!", "img": "assets/images/hall.png"},
    {"msg": "💫 Fun times ahead!", "img": "assets/images/photographer.png"},
    {"msg": "🌟 Keep shining!", "img": "assets/images/chatbot.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F6),

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFFD6E4FF),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            color: Colors.redAccent,
            tooltip: "Logout",
          ),
        ],
      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Row(
                  children: [
                    const Icon(Icons.account_circle, size: 60, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.userEmail,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Funky sliding cards section
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: funkyItems.length,
                    itemBuilder: (context, index) {
                      final item = funkyItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(2, 3),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item['img']!,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['msg']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Optional: Some more info or funky notes
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    "✨ Keep exploring amazing events!\n💡 Fun surprises coming soon!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
          ),

          // Floating chatbot button
          Positioned(
            bottom: 80,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatBotPage(userEmail: widget.userEmail)),
                );
              },
              child: const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/images/chatbot.png'),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _onNavTapped(index);
        },
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Book Event'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
