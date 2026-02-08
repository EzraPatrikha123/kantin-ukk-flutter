class DiskonModel {
  final int? id;
  final String namaDiskon;
  final int persentaseDiskon;
  final String tanggalAwal;
  final String tanggalAkhir;

  DiskonModel({
    this.id,
    required this.namaDiskon,
    required this.persentaseDiskon,
    required this.tanggalAwal,
    required this.tanggalAkhir,
  });

  factory DiskonModel.fromJson(Map<String, dynamic> json) {
    return DiskonModel(
      id: json['id'],
      namaDiskon: json['nama_diskon'] ?? '',
      persentaseDiskon: json['persentase_diskon'] is String
          ? int.tryParse(json['persentase_diskon']) ?? 0
          : json['persentase_diskon'] ?? 0,
      tanggalAwal: json['tanggal_awal'] ?? '',
      tanggalAkhir: json['tanggal_akhir'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama_diskon': namaDiskon,
      'persentase_diskon': persentaseDiskon,
      'tanggal_awal': tanggalAwal,
      'tanggal_akhir': tanggalAkhir,
    };
  }
}
