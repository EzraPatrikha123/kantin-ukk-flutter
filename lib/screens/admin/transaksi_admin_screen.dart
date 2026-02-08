import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaksi_model.dart';
import '../../services/transaksi_service.dart';
import '../../widgets/loading_indicator.dart';

class TransaksiAdminScreen extends StatefulWidget {
  const TransaksiAdminScreen({super.key});

  @override
  State<TransaksiAdminScreen> createState() => _TransaksiAdminScreenState();
}

class _TransaksiAdminScreenState extends State<TransaksiAdminScreen> {
  final _transaksiService = TransaksiService();
  List<TransaksiModel> _transaksiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final result = await _transaksiService.getAllTransaksi();
    if (result['success']) {
      setState(() {
        _transaksiList = result['data'];
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

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'belum dikonfirm':
        return Colors.orange;
      case 'dimasak':
        return Colors.blue;
      case 'diantar':
        return Colors.purple;
      case 'sampai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Transaksi'),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Memuat data...')
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _transaksiList.isEmpty
                  ? const Center(child: Text('Belum ada transaksi'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _transaksiList.length,
                      itemBuilder: (context, index) {
                        final transaksi = _transaksiList[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(transaksi.status),
                              child: const Icon(Icons.receipt, color: Colors.white),
                            ),
                            title: Text(
                              'Transaksi #${transaksi.id}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (transaksi.namaStan != null)
                                  Text('Stan: ${transaksi.namaStan}'),
                                if (transaksi.namaSiswa != null)
                                  Text('Siswa: ${transaksi.namaSiswa}'),
                                Text('Tanggal: ${transaksi.tanggal ?? "-"}'),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(transaksi.status)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    transaksi.status?.toUpperCase() ?? 'UNKNOWN',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(transaksi.status),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              if (transaksi.detailTransaksi != null)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Detail Pesanan:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      ...transaksi.detailTransaksi!.map((detail) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${detail.namaMenu ?? "Menu"} x${detail.qty}',
                                                ),
                                              ),
                                              Text(
                                                formatCurrency(detail.hargaBeli * detail.qty),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            formatCurrency(transaksi.totalHarga ?? 0),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFFFF9800),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
