import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaksi_model.dart';
import '../../services/transaksi_service.dart';
import '../../widgets/loading_indicator.dart';

class TransaksiSiswaScreen extends StatefulWidget {
  const TransaksiSiswaScreen({super.key});

  @override
  State<TransaksiSiswaScreen> createState() => _TransaksiSiswaScreenState();
}

class _TransaksiSiswaScreenState extends State<TransaksiSiswaScreen> {
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
    // TODO: Filter by current siswa's id
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

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'belum dikonfirm':
        return Icons.pending;
      case 'dimasak':
        return Icons.restaurant;
      case 'diantar':
        return Icons.delivery_dining;
      case 'sampai':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Memuat data...')
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _transaksiList.isEmpty
                  ? const Center(
                      child: Text('Belum ada transaksi'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _transaksiList.length,
                      itemBuilder: (context, index) {
                        final transaksi = _transaksiList[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ExpansionTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getStatusColor(transaksi.status)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getStatusIcon(transaksi.status),
                                color: _getStatusColor(transaksi.status),
                              ),
                            ),
                            title: Text(
                              'Transaksi #${transaksi.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (transaksi.namaStan != null)
                                  Text('Stan: ${transaksi.namaStan}'),
                                Text('Tanggal: ${transaksi.tanggal ?? "-"}'),
                                const SizedBox(height: 4),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Detail Pesanan:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...transaksi.detailTransaksi!
                                          .map((detail) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4),
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
                                                formatCurrency(
                                                    detail.hargaBeli *
                                                        detail.qty),
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
                                            formatCurrency(
                                                transaksi.totalHarga ?? 0),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFFFF9800),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Status tracking
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Status Pesanan:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildStatusTracker(transaksi.status),
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

  Widget _buildStatusTracker(String? currentStatus) {
    final statuses = [
      'belum dikonfirm',
      'dimasak',
      'diantar',
      'sampai',
    ];
    final currentIndex = statuses.indexOf(currentStatus ?? '');

    return Column(
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isActive = index <= currentIndex;
        final isLast = index == statuses.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isActive
                        ? _getStatusColor(status)
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: isActive
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 30,
                    color: isActive ? _getStatusColor(status) : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? _getStatusColor(status) : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
