import 'package:flutter/material.dart';
import '../../models/menu_model.dart';
import '../../models/transaksi_model.dart';
import '../../services/menu_service.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/menu_card.dart';
import 'menu_detail_screen.dart';
import 'cart_screen.dart';

// Global cart for simplicity
List<CartItem> globalCart = [];

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  final _menuService = MenuService();
  List<MenuModel> _menuList = [];
  List<MenuModel> _filteredList = [];
  bool _isLoading = true;
  String _selectedJenis = 'semua';

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
        _filteredList = _menuList;
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

  void _filterByJenis(String jenis) {
    setState(() {
      _selectedJenis = jenis;
      if (jenis == 'semua') {
        _filteredList = _menuList;
      } else {
        _filteredList = _menuList.where((m) => m.jenis == jenis).toList();
      }
    });
  }

  void _addToCart(MenuModel menu) {
    setState(() {
      final existingIndex = globalCart.indexWhere((item) => item.idMenu == menu.id);
      if (existingIndex >= 0) {
        globalCart[existingIndex].qty++;
      } else {
        globalCart.add(CartItem(
          idMenu: menu.id!,
          namaMenu: menu.namaMakanan,
          harga: menu.harga,
          qty: 1,
          foto: menu.foto,
          idStan: menu.idStan!,
        ));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${menu.namaMakanan} ditambahkan ke keranjang'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Lihat',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Menu'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              if (globalCart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${globalCart.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua', 'semua'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Makanan', 'makanan'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Minuman', 'minuman'),
                ],
              ),
            ),
          ),
          // List
          Expanded(
            child: _isLoading
                ? const LoadingIndicator(message: 'Memuat menu...')
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: _filteredList.isEmpty
                        ? const Center(child: Text('Menu tidak ditemukan'))
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              final menu = _filteredList[index];
                              return MenuCard(
                                menu: menu,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MenuDetailScreen(menu: menu),
                                    ),
                                  );
                                },
                                onAddToCart: () => _addToCart(menu),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedJenis == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => _filterByJenis(value),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
    );
  }
}
