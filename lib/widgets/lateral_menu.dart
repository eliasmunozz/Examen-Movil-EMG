import 'package:flutter/services.dart';
import 'package:flutter_application_1/theme/theme.dart';
import 'package:flutter_application_1/widgets/custom_notification.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark, 
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: MyTheme.primary,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Menú Principal',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.home,
                text: 'Inicio',
                routeName: 'home',
              ),
              _buildDrawerItem(
                context,
                icon: Icons.error,
                text: 'Vista de error',
                routeName: 'noexisto',
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
        ),
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
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, routeName);
        if (onTapExtra != null) onTapExtra();
      },
    );
  }
}
