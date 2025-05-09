import 'dart:convert';

class Category {
  int categoryId;
  String categoryName;
  String? categoryState;

  Category({
    required this.categoryId,
    required this.categoryName,
    this.categoryState,
  });

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryState: json["category_state"],
      );

  Map<String, dynamic> toJson() {
    final data = {
      "category_id": categoryId,
      "category_name": categoryName,
    };
    if (categoryState != null) {
      data["category_state"] = categoryState!;
    }
    return data;
  }
}

class CategoryList {
  List<Category> listado;

  CategoryList({required this.listado});

  factory CategoryList.fromJson(String str) {
    final decoded = jsonDecode(str);

    if (decoded is Map<String, dynamic> &&
        decoded["Listado Categorias"] != null) {
      final list = List<Map<String, dynamic>>.from(decoded["Listado Categorias"]);
      return CategoryList(
        listado: list.map((e) => Category.fromMap(e)).toList(),
      );
    }

    return CategoryList(listado: []);
  }
}