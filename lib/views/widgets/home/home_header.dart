import 'package:flutter/material.dart';
import '../../screens/notification_screen.dart'; // For navigation

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? avatarAssetPath; // Path for user avatar

  const HomeHeader({
    super.key,
    required this.userName,
    this.avatarAssetPath = 'assets/images/avatar_placeholder.png', // Default placeholder
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
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: ClipOval(
                    // Use AssetImage for local assets
                    child: avatarAssetPath != null
                        ? Image.asset(
                      avatarAssetPath!,
                      fit: BoxFit.cover,
                      // Error handling for image loading
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.person, size: 30, color: Colors.grey.shade400),
                    )
                        : Icon(Icons.person, size: 30, color: Colors.grey.shade400), // Fallback icon
                  ),
                ),
                const SizedBox(width: 12),
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
                IconButton(
                  icon: const Icon(Icons.search, size: 30, color: Colors.black54),
                  onPressed: () {
                    // TODO: Implement search functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Search action not implemented.')),
                    );
                  },
                ),
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