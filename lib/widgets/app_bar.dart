import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isMain;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: isMain
          ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (title == "Listado de productos") {
                  Navigator.pushReplacementNamed(context, 'home');
                } else {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}