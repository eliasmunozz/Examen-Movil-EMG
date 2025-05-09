import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/productos.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:provider/provider.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productImageController = TextEditingController();
  final TextEditingController _productStateController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productImageController.dispose();
    _productStateController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      final newProduct = Listado(
        productId: 0, // Aquí se puede poner un id si lo estás generando desde el servidor
        productName: _productNameController.text,
        productPrice: int.parse(_productPriceController.text),
        productImage: _productImageController.text,
        productState: _productStateController.text,
      );

      final productService = Provider.of<ProductService>(context, listen: false);
      
      await productService.editOrCreateProduct(newProduct);

      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto guardado exitosamente'),
          duration: Duration(seconds: 2),
        ),
      );

      // Limpiar los campos
      _productNameController.clear();
      _productPriceController.clear();
      _productImageController.clear();
      _productStateController.clear();


      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Crear producto'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Nombre del Producto:'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              const Text('Precio:'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _productPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Precio del producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                  if (int.tryParse(value) == null) return 'Debe ser un número';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Imagen (URL):'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _productImageController,
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                  if (!value.startsWith('http')) return 'Debe ser una URL válida';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Estado:'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _productStateController,
                decoration: const InputDecoration(
                  labelText: 'Estado del producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveProduct, // Deshabilitar el botón mientras se guarda
                child: const Text('Guardar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}