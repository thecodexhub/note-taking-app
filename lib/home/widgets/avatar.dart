import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.size = 24, this.imgUrl});
  final double size;
  final String? imgUrl;

  @override
  Widget build(BuildContext context) {
    final imgUrl = this.imgUrl;
    return CircleAvatar(
      radius: size,
      backgroundImage: imgUrl != null && imgUrl.isNotEmpty
          ? NetworkImage(imgUrl, scale: 1)
          : null,
      child: imgUrl == null || imgUrl.isEmpty
          ? Icon(Icons.person_outline, size: size)
          : null,
    );
  }
}
