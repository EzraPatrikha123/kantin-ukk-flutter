import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/menu_model.dart';
import 'auth_service.dart';

class MenuService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getAllMenu() async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse(ApiConfig.menu),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<MenuModel> menuList = (data['data'] as List)
            .map((menu) => MenuModel.fromJson(menu))
            .toList();
        return {'success': true, 'data': menuList};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data menu'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getMenuByStanId(int stanId) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.menu}?id_stan=$stanId'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<MenuModel> menuList = (data['data'] as List)
            .map((menu) => MenuModel.fromJson(menu))
            .toList();
        return {'success': true, 'data': menuList};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data menu'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getMenuById(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.menu}/$id'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final menu = MenuModel.fromJson(data['data']);
        return {'success': true, 'data': menu};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data menu'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> createMenu(MenuModel menu) async {
    try {
      final token = await _authService.getToken();
      final response = await http.post(
        Uri.parse(ApiConfig.menu),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(menu.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Menu berhasil ditambahkan'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menambahkan menu'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> updateMenu(int id, MenuModel menu) async {
    try {
      final token = await _authService.getToken();
      final response = await http.put(
        Uri.parse('${ApiConfig.menu}/$id'),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(menu.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Menu berhasil diupdate'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengupdate menu'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> deleteMenu(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.delete(
        Uri.parse('${ApiConfig.menu}/$id'),
        headers: ApiConfig.headers(token: token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Menu berhasil dihapus'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menghapus menu'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
