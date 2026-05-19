import 'package:flutter/material.dart';
import 'profile.dart';
import 'book_event.dart';
import 'booking_history.dart';
// For ChatBotPage

class EventAllInOnePage extends StatefulWidget {
  final String userEmail;

  const EventAllInOnePage({super.key, required this.userEmail});

  @override
  State<EventAllInOnePage> createState() => _EventAllInOnePageState();
}

class _EventAllInOnePageState extends State<EventAllInOnePage> {
  int _selectedIndex = 0;
  String selectedCategory = 'All';

  List<Map<String, String>> vendors = [
    {
      "image": "assets/images/hall.png",
      "title": "Grand Palace Hall",
      "price": "Starts at ₹2500",
      "rating": "4.9",
      "category": "Halls",
    },
    {
      "image": "assets/images/photographer.png",
      "title": "Timeless Captures",
      "price": "₹₹ - ₹₹₹₹",
      "rating": "4.8",
      "category": "Photographers",
    },
    {
      "image": "assets/images/decorator.png",
      "title": "Fantasy Decorators",
      "price": "Starts at ₹500",
      "rating": "4.7",
      "category": "Decorators",
    },
    {
      "image": "assets/images/caterer.png",
      "title": "Royal Feast Catering",
      "price": "Starts at ₹1500",
      "rating": "4.6",
      "category": "Caterers",
    },
  ];

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);

    Widget page;

    switch (index) {
      case 0:
        return; // Stay on this page
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
        page = EventAllInOnePage(userEmail: widget.userEmail);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredVendors = selectedCategory == 'All'
        ? vendors
        : vendors.where((v) => v["category"] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F6F8),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.celebration, color: Color(0xFFA413EC), size: 30),
            const SizedBox(width: 8),
            const Text(
              'EventAllInOne',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userEmail: widget.userEmail),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Find your perfect event",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/hall.png"),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Book your dream wedding hall",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Find the perfect venue for your special day.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: ["All", "Decorators", "Photographers", "Halls", "Caterers"]
                        .map((category) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: _buildCategoryChip(category, category == selectedCategory),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 10),
                ...filteredVendors.map(
                  (vendor) => _buildVendorCard(
                    imagePath: vendor["image"]!,
                    title: vendor["title"]!,
                    price: vendor["price"]!,
                    rating: vendor["rating"]!,
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

  Widget _buildCategoryChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(colors: [Color(0xFFFFB6C1), Color(0xFFFFA07A)])
            : null,
        color: isActive ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive ? [] : [const BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildVendorCard({
    required String imagePath,
    required String title,
    required String price,
    required String rating,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(imagePath, height: 160, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(price, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 20),
                      const SizedBox(width: 4),
                      Text(rating, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
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
