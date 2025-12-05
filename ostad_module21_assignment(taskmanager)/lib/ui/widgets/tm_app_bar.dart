import 'dart:convert';

import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../screens/sign_in_screen.dart';
import '../screens/update_profile_screen.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({super.key, this.fromUpdateProfile = false});

  final bool fromUpdateProfile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if (fromUpdateProfile) {
            return;
          }

          Navigator.pushNamed(context, UpdateProfileScreen.name);
        },
        child: Row(
          spacing: 12,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: AuthController.user!.photo.isEmpty
                  ? Icon(Icons.person, color: Colors.grey)
                  : ClipOval(
                child: Image.memory(
                  base64Decode(AuthController.user!.photo),
                  fit: BoxFit.cover,
                  width: 48,
                  height: 48,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthController.user?.fullName ?? '',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  AuthController.user?.email ?? '',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await AuthController.clearUserData();
            Navigator.pushNamedAndRemoveUntil(
              context,
              SignInScreen.name,
                  (predicate) => false,
            );
          },
          icon: Icon(Icons.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}