import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/siswa_model.dart';
import 'auth_service.dart';

class SiswaService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getAllSiswa() async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse(ApiConfig.siswa),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<SiswaModel> siswaList = (data['data'] as List)
            .map((siswa) => SiswaModel.fromJson(siswa))
            .toList();
        return {'success': true, 'data': siswaList};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data siswa'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getSiswaById(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.siswa}/$id'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final siswa = SiswaModel.fromJson(data['data']);
        return {'success': true, 'data': siswa};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data siswa'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> createSiswa(SiswaModel siswa) async {
    try {
      final token = await _authService.getToken();
      final response = await http.post(
        Uri.parse(ApiConfig.siswa),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(siswa.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Siswa berhasil ditambahkan'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menambahkan siswa'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> updateSiswa(int id, SiswaModel siswa) async {
    try {
      final token = await _authService.getToken();
      final response = await http.put(
        Uri.parse('${ApiConfig.siswa}/$id'),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(siswa.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Siswa berhasil diupdate'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengupdate siswa'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> deleteSiswa(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.delete(
        Uri.parse('${ApiConfig.siswa}/$id'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Siswa berhasil dihapus'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menghapus siswa'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
