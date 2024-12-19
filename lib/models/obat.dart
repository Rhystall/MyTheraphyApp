class Obat {
  final String nama; // Nama obat
  final DateTime tanggalMulai; // Tanggal mulai konsumsi
  final DateTime tanggalAkhir; // Tanggal akhir konsumsi
  final int jumlah; // Jumlah obat
  final int dosis; // Berapa kali sehari
  final List<String> waktu; // List waktu konsumsi (misalnya ["10:00", "20:00"])
  final bool isAlarm; // Apakah alarm aktif
  final String ringtone; // Ringtone untuk alarm

  Obat({
    required this.nama,
    required this.tanggalMulai,
    required this.tanggalAkhir,
    required this.jumlah,
    required this.dosis,
    required this.waktu,
    this.isAlarm = false, // Default alarm tidak aktif
    this.ringtone = "Default", // Default ringtone
  });

  // Konversi ke JSON (untuk API atau penyimpanan lokal)
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'tanggalMulai': tanggalMulai.toIso8601String(),
      'tanggalAkhir': tanggalAkhir.toIso8601String(),
      'jumlah': jumlah,
      'dosis': dosis,
      'waktu': waktu,
      'isAlarm': isAlarm,
      'ringtone': ringtone,
    };
  }

  // Buat instance dari JSON
  factory Obat.fromJson(Map<String, dynamic> json) {
    return Obat(
      nama: json['nama'],
      tanggalMulai: DateTime.parse(json['tanggalMulai']),
      tanggalAkhir: DateTime.parse(json['tanggalAkhir']),
      jumlah: json['jumlah'],
      dosis: json['dosis'],
      waktu: List<String>.from(json['waktu']),
      isAlarm: json['isAlarm'],
      ringtone: json['ringtone'],
    );
  }
}
