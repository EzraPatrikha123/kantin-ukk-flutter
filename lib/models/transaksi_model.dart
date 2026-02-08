class TransaksiModel {
  final int? id;
  final String? tanggal;
  final int? idStan;
  final int? idSiswa;
  final String? status;
  final String? namaStan;
  final String? namaSiswa;
  final int? totalHarga;
  final List<DetailTransaksiModel>? detailTransaksi;

  TransaksiModel({
    this.id,
    this.tanggal,
    this.idStan,
    this.idSiswa,
    this.status,
    this.namaStan,
    this.namaSiswa,
    this.totalHarga,
    this.detailTransaksi,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id: json['id'],
      tanggal: json['tanggal'],
      idStan: json['id_stan'],
      idSiswa: json['id_siswa'],
      status: json['status'] ?? 'belum dikonfirm',
      namaStan: json['nama_stan'],
      namaSiswa: json['nama_siswa'],
      totalHarga: json['total_harga'] is String
          ? int.tryParse(json['total_harga']) ?? 0
          : json['total_harga'],
      detailTransaksi: json['detail_transaksi'] != null
          ? (json['detail_transaksi'] as List)
              .map((detail) => DetailTransaksiModel.fromJson(detail))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (tanggal != null) 'tanggal': tanggal,
      if (idStan != null) 'id_stan': idStan,
      if (idSiswa != null) 'id_siswa': idSiswa,
      if (status != null) 'status': status,
      if (totalHarga != null) 'total_harga': totalHarga,
      if (detailTransaksi != null)
        'detail_transaksi':
            detailTransaksi!.map((detail) => detail.toJson()).toList(),
    };
  }
}

class DetailTransaksiModel {
  final int? id;
  final int? idTransaksi;
  final int? idMenu;
  final int qty;
  final int hargaBeli;
  final String? namaMenu;

  DetailTransaksiModel({
    this.id,
    this.idTransaksi,
    this.idMenu,
    required this.qty,
    required this.hargaBeli,
    this.namaMenu,
  });

  factory DetailTransaksiModel.fromJson(Map<String, dynamic> json) {
    return DetailTransaksiModel(
      id: json['id'],
      idTransaksi: json['id_transaksi'],
      idMenu: json['id_menu'],
      qty: json['qty'] is String ? int.tryParse(json['qty']) ?? 0 : json['qty'] ?? 0,
      hargaBeli: json['harga_beli'] is String
          ? int.tryParse(json['harga_beli']) ?? 0
          : json['harga_beli'] ?? 0,
      namaMenu: json['nama_menu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (idTransaksi != null) 'id_transaksi': idTransaksi,
      if (idMenu != null) 'id_menu': idMenu,
      'qty': qty,
      'harga_beli': hargaBeli,
    };
  }
}

class CartItem {
  final int idMenu;
  final String namaMenu;
  final int harga;
  int qty;
  final String? foto;
  final int idStan;

  CartItem({
    required this.idMenu,
    required this.namaMenu,
    required this.harga,
    required this.qty,
    this.foto,
    required this.idStan,
  });

  int get totalHarga => harga * qty;
}
