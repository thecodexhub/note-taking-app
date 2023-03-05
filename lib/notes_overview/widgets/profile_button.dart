import 'package:flutter/material.dart';
import 'package:note_taking_app/profile/profile.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key, this.size = 24.0, this.imgUrl});
  final double size;
  final String? imgUrl;

  @override
  Widget build(BuildContext context) {
    final imgUrl = this.imgUrl;
    return InkWell(
      onTap: () => Navigator.of(context).push(ProfilePage.route()),
      child: CircleAvatar(
        radius: size,
        backgroundImage: imgUrl != null && imgUrl.isNotEmpty
            ? NetworkImage(imgUrl, scale: 1)
            : null,
        child: imgUrl == null || imgUrl.isEmpty
            ? Icon(Icons.person_outline, size: size)
            : null,
      ),
    );
  }
}
