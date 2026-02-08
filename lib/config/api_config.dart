class ApiConfig {
  static const String baseUrl = 'https://ukk-p2.smktelkom-mlg.sch.id/api/';
  
  // Auth endpoints
  static const String login = '${baseUrl}login';
  static const String register = '${baseUrl}register';
  static const String logout = '${baseUrl}logout';
  
  // Stan endpoints
  static const String stan = '${baseUrl}stan';
  
  // Menu endpoints
  static const String menu = '${baseUrl}menu';
  
  // Siswa endpoints
  static const String siswa = '${baseUrl}siswa';
  
  // Diskon endpoints
  static const String diskon = '${baseUrl}diskon';
  
  // Transaksi endpoints
  static const String transaksi = '${baseUrl}transaksi';
  
  // Headers
  static Map<String, String> headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  static Map<String, String> multipartHeaders({String? token}) {
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
