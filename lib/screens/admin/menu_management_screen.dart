import 'package:flutter/material.dart';
import '../../models/menu_model.dart';
import '../../services/menu_service.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/menu_card.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final _menuService = MenuService();
  List<MenuModel> _menuList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final result = await _menuService.getAllMenu();
    if (result['success']) {
      setState(() {
        _menuList = result['data'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
  }

  Future<void> _deleteMenu(MenuModel menu) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Hapus menu ${menu.namaMakanan}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final result = await _menuService.deleteMenu(menu.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: result['success'] ? Colors.green : Colors.red,
          ),
        );
        if (result['success']) {
          _loadData();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Menu'),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Memuat data...')
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _menuList.isEmpty
                  ? const Center(child: Text('Belum ada data menu'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _menuList.length,
                      itemBuilder: (context, index) {
                        final menu = _menuList[index];
                        return MenuCard(
                          menu: menu,
                          showActions: true,
                          onDelete: () => _deleteMenu(menu),
                        );
                      },
                    ),
            ),
    );
  }
}
