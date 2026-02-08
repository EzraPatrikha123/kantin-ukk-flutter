class SiswaModel {
  final int? id;
  final String namaSiswa;
  final String? alamat;
  final String? telp;
  final int? idUser;
  final String? foto;

  SiswaModel({
    this.id,
    required this.namaSiswa,
    this.alamat,
    this.telp,
    this.idUser,
    this.foto,
  });

  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      id: json['id'],
      namaSiswa: json['nama_siswa'] ?? '',
      alamat: json['alamat'],
      telp: json['telp'],
      idUser: json['id_user'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama_siswa': namaSiswa,
      if (alamat != null) 'alamat': alamat,
      if (telp != null) 'telp': telp,
      if (idUser != null) 'id_user': idUser,
      if (foto != null) 'foto': foto,
    };
  }
}
