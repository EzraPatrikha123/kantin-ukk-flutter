import 'package:flutter/material.dart';
import '../../models/siswa_model.dart';
import '../../services/siswa_service.dart';
import '../../widgets/loading_indicator.dart';

class SiswaManagementScreen extends StatefulWidget {
  const SiswaManagementScreen({super.key});

  @override
  State<SiswaManagementScreen> createState() => _SiswaManagementScreenState();
}

class _SiswaManagementScreenState extends State<SiswaManagementScreen> {
  final _siswaService = SiswaService();
  List<SiswaModel> _siswaList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final result = await _siswaService.getAllSiswa();
    if (result['success']) {
      setState(() {
        _siswaList = result['data'];
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

  Future<void> _deleteSiswa(SiswaModel siswa) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Hapus siswa ${siswa.namaSiswa}?'),
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
      final result = await _siswaService.deleteSiswa(siswa.id!);
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
        title: const Text('Kelola Siswa'),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Memuat data...')
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _siswaList.isEmpty
                  ? const Center(child: Text('Belum ada data siswa'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _siswaList.length,
                      itemBuilder: (context, index) {
                        final siswa = _siswaList[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              siswa.namaSiswa,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (siswa.alamat != null) Text('Alamat: ${siswa.alamat}'),
                                if (siswa.telp != null) Text('Telp: ${siswa.telp}'),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSiswa(siswa),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
