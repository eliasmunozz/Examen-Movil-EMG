import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyCwQYMMlROaHlO12wGuTuIwBxTezL2iBdU';

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(
      _baseUrl,
      '/v1/accounts:signInWithPassword',
      {'key': _firebaseToken},
    );

    try {
      final response = await http.post(
        url,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> decodeResponse = json.decode(response.body);

      if (decodeResponse.containsKey('idToken')) {
        return null; // Login exitoso
      } else {
        // Firebase devuelve un mensaje de error
        return decodeResponse['error']['message'] ?? 'Error desconocido';
      }
    } on SocketException {
      return 'Sin conexión a internet';
    } catch (e) {
      return 'Error inesperado: ${e.toString()}';
    }
  }
}