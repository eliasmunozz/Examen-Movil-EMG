import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/productos.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:provider/provider.dart';


class ViewProductScreen extends StatelessWidget {
  const ViewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Listado? product = ModalRoute.of(context)?.settings.arguments as Listado?;

    if (product == null) {
      return const Scaffold(
        body: Center(
          child: Text('Producto no encontrado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      );
    }

    //final isNew = product.productId == 0;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Detalles producto'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.network(
                product.productImage,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Image(
                    image: AssetImage('assets/no-image.png'),
                    height: 200,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nombre del Producto:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(product.productName, style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),

                    const Text('Precio:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('\$${product.productPrice}', style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),

                    const Text('Estado:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(product.productState, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
            ActionButton(
              label: 'Editar Producto',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  'edit_product',
                  arguments: product,
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final productService = Provider.of<ProductService>(context, listen: false);

                  try {
                    await productService.deleteProduct(product, context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto eliminado correctamente.'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context); 
                    Navigator.pushNamed(context, 'list_product'); 

                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al eliminar el producto: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                ),
                child: const Text('Borrar Producto'),
              ),
            )
          ],
        ),
      ),
    );
  }
}