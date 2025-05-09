import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/category.dart';

class CategoryService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Category> categories = [];
  bool isLoading = true;
  bool isSaving = false;

  CategoryService() {
    Future.microtask(() => loadCategories());
  }

  Future<void> loadCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.http(_baseUrl, 'ejemplos/category_list_rest/');
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

      final res = await http.get(url, headers: {'authorization': basicAuth});
      if (res.statusCode == 200) {
        final parsed = CategoryList.fromJson(res.body);
        categories = parsed.listado;
      } else {
        throw Exception('Error al cargar categorías. Código: ${res.statusCode}');
      }
    } catch (e) {
      print('Error en loadCategories: $e');
      categories = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveCategory(Category category) async {
    isSaving = true;
    notifyListeners();

    try {
      if (category.categoryId == 0) {
        await createCategory(category);
      } else {
        await updateCategory(category);
      }
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> createCategory(Category category) async {
    final url = Uri.http(_baseUrl, 'ejemplos/category_add_rest/');
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    final res = await http.post(
      url,
      headers: {'authorization': basicAuth, 'Content-Type': 'application/json'},
      body: jsonEncode({"category_name": category.categoryName}),
    );

    if (res.statusCode == 200) {
      await loadCategories(); // reload after create
    } else {
      throw Exception('Fallo al crear categoría');
    }
  }

  Future<void> updateCategory(Category category) async {
    final url = Uri.http(_baseUrl, 'ejemplos/category_edit_rest/');
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    final res = await http.post(
      url,
      headers: {'authorization': basicAuth, 'Content-Type': 'application/json'},
      body: jsonEncode(category.toJson()),
    );

    if (res.statusCode == 200) {
      await loadCategories(); // reload after update
    } else {
      throw Exception('Fallo al actualizar categoría');
    }
  }

  Future<void> deleteCategory(Category category) async {
    final url = Uri.http(_baseUrl, 'ejemplos/category_del_rest/');
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

    final res = await http.post(
      url,
      headers: {'authorization': basicAuth, 'Content-Type': 'application/json'},
      body: jsonEncode({"category_id": category.categoryId}),
    );

    if (res.statusCode == 200) {
      await loadCategories(); // reload after delete
    } else {
      throw Exception('Fallo al eliminar categoría');
    }
  }
}