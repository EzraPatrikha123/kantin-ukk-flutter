class StanModel {
  final int? id;
  final String namaStan;
  final String namaPemilik;
  final String telp;
  final int? idUser;

  StanModel({
    this.id,
    required this.namaStan,
    required this.namaPemilik,
    required this.telp,
    this.idUser,
  });

  factory StanModel.fromJson(Map<String, dynamic> json) {
    return StanModel(
      id: json['id'],
      namaStan: json['nama_stan'] ?? '',
      namaPemilik: json['nama_pemilik'] ?? '',
      telp: json['telp'] ?? '',
      idUser: json['id_user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama_stan': namaStan,
      'nama_pemilik': namaPemilik,
      'telp': telp,
      if (idUser != null) 'id_user': idUser,
    };
  }
}
