import 'package:flutter/material.dart';
import '../../screens/notification_screen.dart'; // For navigation

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, // Only apply safe area to the top
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 15, 24, 10), // Adjust top padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User Greeting and Avatar
            Row(
              children: [
                // Welcome Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(
                      userName.isNotEmpty ? userName : 'Pengguna', // Handle empty name
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Prevent overflow
                    ),
                  ],
                ),
              ],
            ),
            // Action Icons (Search & Notifications)
            Row(
              children: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_outlined, size: 30, color: Colors.black54), // Use outlined icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationScreen()),
                        );
                      },
                    ),
                    // Notification Badge (Optional)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFCC00), // Example badge color
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}