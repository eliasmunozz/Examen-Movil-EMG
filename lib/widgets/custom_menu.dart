import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/theme.dart';
import 'package:flutter_application_1/widgets/custom_notification.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: MyTheme.primary,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Menú Principal',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            text: 'Inicio',
            routeName: 'home',
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: 'Cerrar Sesión',
            routeName: 'login',
            onTapExtra: () {
              CustomNotification.show(
                context,
                message: 'Sesión Cerrada',
                backgroundColor: Colors.green,
                icon: Icons.check_circle,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String routeName,
    VoidCallback? onTapExtra,
  }) {
    return ListTile(
      leading: Icon(icon, color: MyTheme.primary),
      title: Text(text),
      onTap: () {
        Navigator.pop(context); // Cierra el Drawer
        Navigator.pushReplacementNamed(context, routeName);
        if (onTapExtra != null) onTapExtra();
      },
    );
  }
}