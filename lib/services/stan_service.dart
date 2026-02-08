import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/stan_model.dart';
import 'auth_service.dart';

class StanService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getAllStan() async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse(ApiConfig.stan),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<StanModel> stanList = (data['data'] as List)
            .map((stan) => StanModel.fromJson(stan))
            .toList();
        return {'success': true, 'data': stanList};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data stan'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getStanById(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.stan}/$id'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final stan = StanModel.fromJson(data['data']);
        return {'success': true, 'data': stan};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data stan'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> createStan(StanModel stan) async {
    try {
      final token = await _authService.getToken();
      final response = await http.post(
        Uri.parse(ApiConfig.stan),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(stan.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Stan berhasil ditambahkan'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menambahkan stan'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> updateStan(int id, StanModel stan) async {
    try {
      final token = await _authService.getToken();
      final response = await http.put(
        Uri.parse('${ApiConfig.stan}/$id'),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(stan.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Stan berhasil diupdate'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengupdate stan'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> deleteStan(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.delete(
        Uri.parse('${ApiConfig.stan}/$id'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Stan berhasil dihapus'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menghapus stan'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
