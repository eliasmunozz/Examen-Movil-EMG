import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/provider.dart';

class ProviderService with ChangeNotifier {
  final String _baseUrl = "143.198.118.203:8100";
  final String _user = "test";
  final String _pass = "test2023";

  List<ProviderModel> providers = [];
  bool isLoading = true;

  ProviderService() {
    loadProviders();
  }

  Future<void> loadProviders() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/ejemplos/provider_list_rest/');

    try {
      final response = await http.get(url, headers: _headers());

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic> && decoded.containsKey('Proveedores Listado')) {
          final list = decoded['Proveedores Listado'];
          providers = List<ProviderModel>.from(list.map((e) => ProviderModel.fromJson(e)));
        } else {
          providers = [];
        }
      } else {
        providers = [];
      }
    } on SocketException {
      providers = [];
      print("No hay conexión a Internet");
    } catch (e) {
      
      providers = [];
      print("Error inesperado: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> saveProvider(ProviderModel provider) async {
    final isNew = provider.providerId == 0;
    final url = Uri.http(
      _baseUrl,
      isNew ? '/ejemplos/provider_add_rest/' : '/ejemplos/provider_edit_rest/',
    );

    final data = json.encode(provider.toJson());

    print('Enviando ${isNew ? 'nuevo' : 'actualización'}:');
    print('URL: $url');
    print('Body: $data');

    try {
      final response = await http.post(
        url,
        headers: _headers(),
        body: data,
      );

      print('Código respuesta: ${response.statusCode}');

      final body = json.decode(response.body);
      print('Respuesta parseada: ${body is Map ? body['message'] ?? body : body}');

      if (response.statusCode == 200) {
        await loadProviders();
      } else {
        throw Exception('Error al guardar proveedor');
      }
    } on SocketException {
      print("No hay conexión a Internet al guardar el proveedor");
      throw Exception('No hay conexión a Internet');
    } catch (e) {
      print("Error inesperado: $e");
      throw Exception('Error inesperado al guardar proveedor');
    }
  }

  Future<void> deleteProvider(ProviderModel provider) async {
    final url = Uri.http(_baseUrl, '/ejemplos/provider_del_rest/');

    try {
      final response = await http.post(
        url,
        headers: _headers(),
        body: json.encode({'provider_id': provider.providerId}),
      );

      if (response.statusCode == 200) {
        await loadProviders();
      } else {
        throw Exception('Error al eliminar proveedor');
      }
    } on SocketException {
      print("No hay conexión a Internet al eliminar el proveedor");
      throw Exception('No hay conexión a Internet');
    } catch (e) {
      print("Error inesperado: $e");
      throw Exception('Error inesperado al eliminar proveedor');
    }
  }

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'authorization':
            'Basic ${base64Encode(utf8.encode("$_user:$_pass"))}',
      };
}