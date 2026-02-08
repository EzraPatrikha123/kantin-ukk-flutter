import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/diskon_model.dart';
import 'auth_service.dart';

class DiskonService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getAllDiskon() async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse(ApiConfig.diskon),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<DiskonModel> diskonList = (data['data'] as List)
            .map((diskon) => DiskonModel.fromJson(diskon))
            .toList();
        return {'success': true, 'data': diskonList};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data diskon'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getDiskonById(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.diskon}/$id'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final diskon = DiskonModel.fromJson(data['data']);
        return {'success': true, 'data': diskon};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data diskon'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> createDiskon(DiskonModel diskon) async {
    try {
      final token = await _authService.getToken();
      final response = await http.post(
        Uri.parse(ApiConfig.diskon),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(diskon.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Diskon berhasil ditambahkan'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menambahkan diskon'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> updateDiskon(int id, DiskonModel diskon) async {
    try {
      final token = await _authService.getToken();
      final response = await http.put(
        Uri.parse('${ApiConfig.diskon}/$id'),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(diskon.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Diskon berhasil diupdate'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengupdate diskon'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> deleteDiskon(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.delete(
        Uri.parse('${ApiConfig.diskon}/$id'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Diskon berhasil dihapus'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menghapus diskon'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
