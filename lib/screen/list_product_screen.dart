import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/productos.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:flutter_application_1/services/product_service.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key});

  @override
  _ListProductScreenState createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    if (productService.isLoading && productService.products.isEmpty) {
      return const LoadingScreen();
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Listado de productos', isMain: false),
      body: productService.products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.signal_wifi_off, size: 50, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'No se pudo cargar la lista de productos.\nPor favor, verifique su conexión.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Intenta recargar la lista de productos
                      await productService.loadProducts();
                    },
                    child: const Text('Recargar'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: productService.products.length,
                    itemBuilder: (context, index) {
                      final Listado product = productService.products[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'view_product',
                            arguments: product,
                          );
                        },
                        child: ProductCard(product: product),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, 'new_product').then((newProduct) {
            if (newProduct != null && newProduct is Listado) {
              productService.addProduct(newProduct);
              productService.editOrCreateProduct(newProduct);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}