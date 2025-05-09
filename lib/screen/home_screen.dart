import 'package:flutter_application_1/theme/theme.dart';
import 'package:flutter_application_1/widgets/widgets.dart'; // Para CustomAppBar y CustomDrawer

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Inicio', isMain: true),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _HomeButton(
              icon: Icons.shopping_cart,
              label: 'Productos',
              onTap: () {
                Navigator.pushNamed(context, 'list_product');
              },
            ),
            _HomeButton(
              icon: Icons.category,
              label: 'Categorías',
              onTap: () {
                Navigator.pushNamed(context, 'list_category');
              },
            ),
            _HomeButton(
              icon: Icons.people,
              label: 'Proveedores',
              onTap: () {
                Navigator.pushNamed(context, 'list_provider');
              },
            )
          ],
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: MyTheme.primary,
        foregroundColor: Colors.white,
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
