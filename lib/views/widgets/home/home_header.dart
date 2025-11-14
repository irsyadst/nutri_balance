import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final bool hasUnreadNotifications;
  final VoidCallback onNotificationTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.hasUnreadNotifications,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 15, 24, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Welcome Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(
                      userName.isNotEmpty ? userName : 'Pengguna',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
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
                      icon: const Icon(Icons.notifications_none_outlined, size: 30, color: Colors.black54),
                      onPressed: onNotificationTap,
                    ),
                    if (hasUnreadNotifications)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFCC00),
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