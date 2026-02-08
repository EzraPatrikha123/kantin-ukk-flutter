import 'package:flutter/material.dart';
import '../../models/diskon_model.dart';
import '../../services/diskon_service.dart';
import '../../widgets/loading_indicator.dart';

class DiskonManagementScreen extends StatefulWidget {
  const DiskonManagementScreen({super.key});

  @override
  State<DiskonManagementScreen> createState() => _DiskonManagementScreenState();
}

class _DiskonManagementScreenState extends State<DiskonManagementScreen> {
  final _diskonService = DiskonService();
  List<DiskonModel> _diskonList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final result = await _diskonService.getAllDiskon();
    if (result['success']) {
      setState(() {
        _diskonList = result['data'];
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

  Future<void> _deleteDiskon(DiskonModel diskon) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Hapus diskon ${diskon.namaDiskon}?'),
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
      final result = await _diskonService.deleteDiskon(diskon.id!);
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
        title: const Text('Kelola Diskon'),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Memuat data...')
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _diskonList.isEmpty
                  ? const Center(child: Text('Belum ada data diskon'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _diskonList.length,
                      itemBuilder: (context, index) {
                        final diskon = _diskonList[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.purple,
                              child: Text(
                                '${diskon.persentaseDiskon}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              diskon.namaDiskon,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${diskon.tanggalAwal} - ${diskon.tanggalAkhir}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteDiskon(diskon),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
