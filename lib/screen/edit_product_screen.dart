import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/productos.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/services/services.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _productNameController;
  late TextEditingController _productPriceController;
  late TextEditingController _productImageController;
  late TextEditingController _productStateController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Listado product = ModalRoute.of(context)?.settings.arguments as Listado;
    _productNameController = TextEditingController(text: product.productName);
    _productPriceController = TextEditingController(text: product.productPrice.toString());
    _productImageController = TextEditingController(text: product.productImage);
    _productStateController = TextEditingController(text: product.productState);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productImageController.dispose();
    _productStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Listado product = ModalRoute.of(context)?.settings.arguments as Listado;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Editar Producto'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nombre del Producto:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _productNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Precio:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _productPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio del producto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Imagen (URL):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _productImageController,
              decoration: const InputDecoration(
                labelText: 'URL de la imagen',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Estado:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _productStateController,
              decoration: const InputDecoration(
                labelText: 'Estado del producto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_productNameController.text.trim().isEmpty ||
                      _productPriceController.text.trim().isEmpty ||
                      _productImageController.text.trim().isEmpty ||
                      _productStateController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, completa todos los campos.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final parsedPrice = int.tryParse(_productPriceController.text.trim());
                  if (parsedPrice == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El precio debe ser un número válido.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  product.productName = _productNameController.text.trim();
                  product.productPrice = parsedPrice;
                  product.productImage = _productImageController.text.trim();
                  product.productState = _productStateController.text.trim();

                  final productService = Provider.of<ProductService>(context, listen: false);

                  try {
                    await productService.editOrCreateProduct(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto actualizado correctamente.'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context, product);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al actualizar el producto: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Guardar Cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}