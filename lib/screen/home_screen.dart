import 'package:flutter_application_1/theme/theme.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

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
            HomeButton(
              icon: Icons.shopping_cart,
              label: 'Productos',
              onTap: () {
                Navigator.pushNamed(context, 'list_product');
              },
            ),
            HomeButton(
              icon: Icons.category,
              label: 'Categorías',
              onTap: () {
                Navigator.pushNamed(context, 'list_category');
              },
            ),
            HomeButton(
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
