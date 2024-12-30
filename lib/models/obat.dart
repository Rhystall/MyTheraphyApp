class Obat {
  int? id;
  String nama;
  DateTime tanggalMulai;
  DateTime tanggalAkhir;
  int jumlah;
  int dosis;
  List<String> waktu;
  bool isAlarm;
  List<String>? waktuAlarm; // Ubah menjadi nullable
  List<DateTime> tanggalKonsumsi; // Tambahan: Tanggal konsumsi yang tersisa

  Obat({
    this.id,
    required this.nama,
    required this.tanggalMulai,
    required this.tanggalAkhir,
    required this.jumlah,
    required this.dosis,
    required this.waktu,
    this.isAlarm = false,
    this.waktuAlarm, // Tidak perlu nilai default
    required this.tanggalKonsumsi,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'tanggalMulai': tanggalMulai.toIso8601String(),
      'tanggalAkhir': tanggalAkhir.toIso8601String(),
      'jumlah': jumlah,
      'dosis': dosis,
      'waktu': waktu.join(','), // Simpan waktu sebagai string
      'isAlarm': isAlarm ? 1 : 0,
      'waktuAlarm': waktuAlarm?.join(','), // Jika null, hasilnya tetap null
      'tanggalKonsumsi': tanggalKonsumsi
          .map((e) => e.toIso8601String())
          .join(','), // Simpan sebagai string
    };
  }

  factory Obat.fromJson(Map<String, dynamic> json) {
    return Obat(
      id: json['id'],
      nama: json['nama'],
      tanggalMulai: DateTime.parse(json['tanggalMulai']),
      tanggalAkhir: DateTime.parse(json['tanggalAkhir']),
      jumlah: json['jumlah'],
      dosis: json['dosis'],
      waktu: (json['waktu'] as String).split(','),
      isAlarm: json['isAlarm'] == 1,
      waktuAlarm: json['waktuAlarm'] != null
          ? (json['waktuAlarm'] as String).split(',')
          : null, // Cek null sebelum parsing
      tanggalKonsumsi: (json['tanggalKonsumsi'] as String)
          .split(',')
          .map((e) => DateTime.parse(e))
          .toList(),
    );
  }
}
