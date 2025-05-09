import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:flutter_application_1/services/category_service.dart';
import 'package:flutter_application_1/widgets/custom_notification.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);

    if (categoryService.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: categoryService.categories.isEmpty
          ? const Center(
              child: Text(
                'No se pudieron cargar las categorías.\nRevisa tu conexión o vuelve a intentar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            )
          : ListView.builder(
              itemCount: categoryService.categories.length,
              itemBuilder: (_, index) {
                final category = categoryService.categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.categoryName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(category.categoryState ?? 'Sin estado'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () => _viewDialog(context, category),
                              icon: const Icon(Icons.visibility),
                              label: const Text('Ver'),
                            ),
                            TextButton.icon(
                              onPressed: () => _editDialog(context, categoryService, category),
                              icon: const Icon(Icons.edit),
                              label: const Text('Editar'),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                try {
                                  await categoryService.deleteCategory(category);
                                  CustomNotification.show(
                                    context,
                                    message: 'Categoría eliminada',
                                    backgroundColor: Colors.green,
                                    icon: Icons.check_circle,
                                  );
                                } catch (e) {
                                  CustomNotification.show(
                                    context,
                                    message: 'Error al eliminar: $e',
                                    backgroundColor: Colors.red,
                                    icon: Icons.error,
                                  );
                                }
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text('Borrar', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editDialog(context, categoryService, Category(categoryId: 0, categoryName: "")),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editDialog(BuildContext context, CategoryService service, Category category) {
    final controller = TextEditingController(text: category.categoryName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(category.categoryId == 0 ? 'Agregar Categoría' : 'Editar Categoría'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nombre de la categoría'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El nombre no puede estar vacío')),
                );
                return;
              }

              try {
                category.categoryName = name;
                if (category.categoryId != 0) category.categoryState = 'Activa';
                await service.saveCategory(category);
                Navigator.pop(context);
                CustomNotification.show(
                  context,
                  message: 'Categoría guardada',
                  backgroundColor: Colors.green,
                  icon: Icons.check_circle,
                );
              } catch (e) {
                CustomNotification.show(
                  context,
                  message: 'Error al guardar: $e',
                  backgroundColor: Colors.red,
                  icon: Icons.error,
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _viewDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ver Categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${category.categoryName}'),
            const SizedBox(height: 8),
            Text('Estado: ${category.categoryState ?? 'Sin estado'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}




