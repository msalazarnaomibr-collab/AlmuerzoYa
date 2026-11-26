
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static const storage = FlutterSecureStorage();

  // LEER RESPUESTA
  static Map<String, dynamic> _leerRespuesta(
      http.Response response,
      ) {
    if (response.body.isEmpty) return {};

    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  // INICIAR SESIÓN
  static Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = _leerRespuesta(response);

    if (response.statusCode == 200) {
      await storage.write(
        key: 'token',
        value: data['token'],
      );

      await storage.write(
        key: 'email',
        value: data['email'],
      );

      return data;
    }

    throw Exception(
      data['message'] ?? 'Correo o contraseña incorrectos',
    );
  }

  // REGISTRAR USUARIO
  static Future<Map<String, dynamic>> register(
      String nombre,
      String email,
      String password,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
        'password': password,
      }),
    );

    final data = _leerRespuesta(response);

    if (response.statusCode == 201) {
      await storage.write(
        key: 'token',
        value: data['token'],
      );

      await storage.write(
        key: 'email',
        value: data['email'],
      );

      return data;
    }

    throw Exception(
      data['message'] ?? 'No se pudo registrar el usuario',
    );
  }

  // OBTENER TOKEN
  static Future<String?> getToken() async {
    return storage.read(key: 'token');
  }

  // CERRAR SESIÓN
  static Future<void> logout() async {
    await storage.deleteAll();
  }

  // ENCABEZADOS CON TOKEN
  static Future<Map<String, String>> _headers() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Inicia sesión nuevamente');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // COMPROBAR SESIÓN
  static Future<void> _comprobarSesion(
      http.Response response,
      ) async {
    if (response.statusCode == 401) {
      await logout();

      throw Exception(
        'Sesión expirada. Inicia sesión nuevamente.',
      );
    }
  }

  // LISTAR PEDIDOS
  static Future<List<dynamic>> getAlmuerzos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/almuerzos'),
      headers: await _headers(),
    );

    await _comprobarSesion(response);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('No se pudieron cargar los pedidos');
  }

  // REGISTRAR PEDIDO
  static Future<void> crearAlmuerzo(
      String cliente,
      String plato,
      int cantidad,
      double precio,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/almuerzos'),
      headers: await _headers(),
      body: jsonEncode({
        'cliente': cliente,
        'plato': plato,
        'cantidad': cantidad,
        'precio': precio,
      }),
    );

    await _comprobarSesion(response);

    if (response.statusCode != 201 &&
        response.statusCode != 200) {
      final data = _leerRespuesta(response);

      throw Exception(
        data['message'] ?? 'No se pudo registrar el pedido',
      );
    }
  }

  // ACTUALIZAR PEDIDO
  static Future<void> actualizarAlmuerzo(
      int id,
      String cliente,
      String plato,
      int cantidad,
      double precio,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/almuerzos/$id'),
      headers: await _headers(),
      body: jsonEncode({
        'cliente': cliente,
        'plato': plato,
        'cantidad': cantidad,
        'precio': precio,
      }),
    );

    await _comprobarSesion(response);

    if (response.statusCode != 200) {
      throw Exception('No se pudo actualizar el pedido');
    }
  }

  // MARCAR PEDIDO COMO ENTREGADO
  static Future<void> marcarEntregado(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/almuerzos/$id/entregado'),
      headers: await _headers(),
    );

    await _comprobarSesion(response);

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw Exception('No se pudo actualizar el estado');
    }
  }

  // ELIMINAR PEDIDO
  static Future<void> eliminarAlmuerzo(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/almuerzos/$id'),
      headers: await _headers(),
    );

    await _comprobarSesion(response);

    if (response.statusCode != 204 &&
        response.statusCode != 200) {
      throw Exception('No se pudo eliminar el pedido');
    }
  }
}
