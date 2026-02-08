class MenuModel {
  final int? id;
  final String namaMakanan;
  final int harga;
  final String jenis;
  final String? foto;
  final String? deskripsi;
  final int? idStan;
  final String? namaStan;

  MenuModel({
    this.id,
    required this.namaMakanan,
    required this.harga,
    required this.jenis,
    this.foto,
    this.deskripsi,
    this.idStan,
    this.namaStan,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      namaMakanan: json['nama_makanan'] ?? '',
      harga: json['harga'] is String 
          ? int.tryParse(json['harga']) ?? 0 
          : json['harga'] ?? 0,
      jenis: json['jenis'] ?? 'makanan',
      foto: json['foto'],
      deskripsi: json['deskripsi'],
      idStan: json['id_stan'],
      namaStan: json['nama_stan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama_makanan': namaMakanan,
      'harga': harga,
      'jenis': jenis,
      if (foto != null) 'foto': foto,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (idStan != null) 'id_stan': idStan,
    };
  }
}
