import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaksi_model.dart';
import '../../services/transaksi_service.dart';
import '../../widgets/loading_indicator.dart';

class StanTransaksiScreen extends StatefulWidget {
  const StanTransaksiScreen({super.key});

  @override
  State<StanTransaksiScreen> createState() => _StanTransaksiScreenState();
}

class _StanTransaksiScreenState extends State<StanTransaksiScreen> {
  final _transaksiService = TransaksiService();
  List<TransaksiModel> _transaksiList = [];
  bool _isLoading = true;
  String _selectedStatus = 'semua';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    // In real implementation, filter by current stan's id
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

  List<TransaksiModel> get _filteredList {
    if (_selectedStatus == 'semua') return _transaksiList;
    return _transaksiList
        .where((t) => t.status == _selectedStatus)
        .toList();
  }

  Future<void> _updateStatus(TransaksiModel transaksi, String newStatus) async {
    final result = await _transaksiService.updateTransaksiStatus(
      transaksi.id!,
      newStatus,
    );
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

  String? _getNextStatus(String? currentStatus) {
    switch (currentStatus) {
      case 'belum dikonfirm':
        return 'dimasak';
      case 'dimasak':
        return 'diantar';
      case 'diantar':
        return 'sampai';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Stan'),
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
                  _buildFilterChip('Belum Dikonfirm', 'belum dikonfirm'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Dimasak', 'dimasak'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Diantar', 'diantar'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Sampai', 'sampai'),
                ],
              ),
            ),
          ),
          // List
          Expanded(
            child: _isLoading
                ? const LoadingIndicator(message: 'Memuat data...')
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: _filteredList.isEmpty
                        ? const Center(child: Text('Belum ada transaksi'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              final transaksi = _filteredList[index];
                              final nextStatus = _getNextStatus(transaksi.status);
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ExpansionTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        _getStatusColor(transaksi.status),
                                    child: const Icon(Icons.receipt,
                                        color: Colors.white),
                                  ),
                                  title: Text(
                                    'Transaksi #${transaksi.id}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                          transaksi.status?.toUpperCase() ??
                                              'UNKNOWN',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: _getStatusColor(
                                                transaksi.status),
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            ...transaksi.detailTransaksi!
                                                .map((detail) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                            if (nextStatus != null) ...[
                                              const SizedBox(height: 12),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () => _updateStatus(
                                                      transaksi, nextStatus),
                                                  child: Text(
                                                      'Update ke ${nextStatus.toUpperCase()}'),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
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
    final isSelected = _selectedStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedStatus = value);
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
    );
  }
}
