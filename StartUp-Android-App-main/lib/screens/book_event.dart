import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'event_all_in_one.dart';
import 'profile.dart';
import 'booking_history.dart';

class BookEventPage extends StatefulWidget {
  final String userEmail;
  const BookEventPage({super.key, required this.userEmail});

  @override
  State<BookEventPage> createState() => _BookEventPageState();
}

class _BookEventPageState extends State<BookEventPage> {
  int _selectedIndex = 2;
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> events = [
    {"category": "Function Hall", "name": "Grand Palace Hall", "location": "Hyderabad"},
    {"category": "Photographer", "name": "Timeless Captures", "location": "Vijayawada"},
    {"category": "Decorator", "name": "Royal Decorators", "location": "Guntur"},
    {"category": "Caterer", "name": "Food Fiesta", "location": "Nellore"},
    {"category": "DJ / Entertainment", "name": "DJ Thunder", "location": "Vizag"},
  ];

  List<Map<String, String>> get filteredEvents => searchQuery.isEmpty
      ? events
      : events.where((event) => event['name']!.toLowerCase().contains(searchQuery.toLowerCase())).toList();

  Future<void> bookEvent(String eventName, String location, String date, String time, int seats) async {
    try {
      final response = await http.post(
        Uri.parse("https://eventallinone-backend.onrender.com/api/events"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": 0,
          "eventName": eventName,
          "location": location,
          "date": date,
          "time": time,
          "availableSeats": seats,
          "userEmail": widget.userEmail,
        }),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.statusCode == 200 || response.statusCode == 201
                ? "🎉 Booking Successful!"
                : "❌ Booking Failed",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠ Error: $e")),
      );
    }
  }

  Future<void> _onNavTapped(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? widget.userEmail;

    setState(() => _selectedIndex = index);

    Widget page = switch (index) {
      0 => EventAllInOnePage(userEmail: email),
      1 => ProfilePage(userEmail: email),
      2 => BookEventPage(userEmail: email),
      3 => BookingHistoryPage(userEmail: email),
      _ => BookEventPage(userEmail: email),
    };

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(toolbarHeight: 0, elevation: 0),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("assets/images/profile.png"),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Email", style: TextStyle(fontSize: 14, color: Colors.grey)),
                            Text(widget.userEmail,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.notifications_none, size: 30),
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Search Event",
                    prefixIcon: const Icon(Icons.search, size: 26),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Popular Services", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (_, index) => _modernEventCard(
                      title: filteredEvents[index]['name']!,
                      location: filteredEvents[index]['location']!,
                      image: _getImage(filteredEvents[index]['category']!),
                      seats: index == 0 ? "33 people joined" : "20+ joined",
                    ),
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
        onTap: _onNavTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.event_available), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }

  String _getImage(String category) {
    switch (category) {
      case "Function Hall":
        return "assets/images/hall.png";
      case "Photographer":
        return "assets/images/photographer.png";
      case "Decorator":
        return "assets/images/decorator.png";
      case "Caterer":
        return "assets/images/caterer.png";
      case "DJ / Entertainment":
        return "assets/images/dj.png";
      default:
        return "assets/images/event.png";
    }
  }

  Widget _modernEventCard({
    required String title,
    required String location,
    required String image,
    required String seats,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(image, height: 70, width: 70, fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(location, style: const TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    const Icon(Icons.people, size: 18),
                    Text(seats, style: const TextStyle(fontSize: 13)),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _openBookingDialog(title, location),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFDAB3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Book"),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _openBookingDialog(String title, String location) async {
    final date = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2026));
    if (date == null) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;

    TextEditingController seatsController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Enter Details for $title"),
        content: TextField(
          controller: seatsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Guests", border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              bookEvent(title, location, date.toString().split(" ")[0],
                  "${time.hour}:${time.minute}", int.parse(seatsController.text));
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}

// Professional ChatBot Page with horizontal sliding queries
class ChatBotPage extends StatefulWidget {
  final String userEmail;
  const ChatBotPage({super.key, required this.userEmail});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> with TickerProviderStateMixin {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();

  final List<String> quickQueries = [
    "Booking Help",
    "Event Info",
    "Payment Support",
    "Venue Details",
    "Cancellation Policy"
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      messages.add({"user": text});
      messages.add({"bot": "Thank you for your query. We will get back to you shortly."});
    });
    _controller.clear();
  }

  Widget _slideMessage(Map<String, String> msg) {
    final isUser = msg.containsKey("user");
    final animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    final animation = Tween<Offset>(
            begin: isUser ? const Offset(1, 0) : const Offset(-1, 0),
            end: Offset.zero)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    animationController.forward();
    return SlideTransition(
      position: animation,
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: isUser ? const Color(0xFFFFE5B4) : const Color(0xFFFFF2E0),
              borderRadius: BorderRadius.circular(12)),
          child: Text(
            isUser ? msg["user"]! : msg["bot"]!,
            style: TextStyle(color: isUser ? Colors.deepPurple : Colors.black87),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF2E0), // Pistachio-orange background
      appBar: AppBar(title: const Text("Customer Support"), backgroundColor: Colors.deepPurple),
      body: Column(
        children: [
          // Horizontal sliding quick queries
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: quickQueries.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade100,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => _sendMessage(quickQueries[index]),
                    child: Text(quickQueries[index]),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (_, index) => _slideMessage(messages[index]),
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
