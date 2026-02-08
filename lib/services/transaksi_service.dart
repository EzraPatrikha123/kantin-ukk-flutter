import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/transaksi_model.dart';
import 'auth_service.dart';

class TransaksiService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getAllTransaksi() async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse(ApiConfig.transaksi),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<TransaksiModel> transaksiList = (data['data'] as List)
            .map((transaksi) => TransaksiModel.fromJson(transaksi))
            .toList();
        return {'success': true, 'data': transaksiList};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data transaksi'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getTransaksiByStanId(int stanId) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.transaksi}?id_stan=$stanId'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<TransaksiModel> transaksiList = (data['data'] as List)
            .map((transaksi) => TransaksiModel.fromJson(transaksi))
            .toList();
        return {'success': true, 'data': transaksiList};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data transaksi'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getTransaksiBySiswaId(int siswaId) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.transaksi}?id_siswa=$siswaId'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<TransaksiModel> transaksiList = (data['data'] as List)
            .map((transaksi) => TransaksiModel.fromJson(transaksi))
            .toList();
        return {'success': true, 'data': transaksiList};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data transaksi'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getTransaksiById(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.transaksi}/$id'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final transaksi = TransaksiModel.fromJson(data['data']);
        return {'success': true, 'data': transaksi};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data transaksi'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> createTransaksi(
      TransaksiModel transaksi) async {
    try {
      final token = await _authService.getToken();
      final response = await http.post(
        Uri.parse(ApiConfig.transaksi),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(transaksi.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Transaksi berhasil dibuat'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal membuat transaksi'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> updateTransaksiStatus(
      int id, String status) async {
    try {
      final token = await _authService.getToken();
      final response = await http.put(
        Uri.parse('${ApiConfig.transaksi}/$id'),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode({'status': status}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Status transaksi berhasil diupdate'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengupdate status transaksi'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> deleteTransaksi(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.delete(
        Uri.parse('${ApiConfig.transaksi}/$id'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Transaksi berhasil dihapus'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menghapus transaksi'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
