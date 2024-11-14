import 'dart:collection';

// Enum untuk Fase Proyek
enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

// Kelas ProdukDigital
class ProdukDigital {
  String namaProduk;
  double harga;
  String kategori;
  int jumlahTerjual;

  ProdukDigital(this.namaProduk, this.harga, this.kategori, this.jumlahTerjual);

  void terapkanDiskon() {
    if (kategori == 'NetworkAutomation' && jumlahTerjual > 50) {
      harga *= 0.85;
      if (harga < 200000) harga = 200000;
      print('Diskon diterapkan pada $namaProduk. Harga baru: $harga');
    } else {
      print('Diskon tidak memenuhi syarat untuk $namaProduk.');
    }
  }
}

// Kelas abstrak Karyawan
abstract class Karyawan {
  String nama;
  int umur;
  String peran;

  Karyawan(this.nama, {required this.umur, required this.peran});

  void bekerja();
}

// KaryawanTetap dan KaryawanKontrak
class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print('$nama bekerja pada hari kerja reguler sebagai $peran.');
  }
}

class KaryawanKontrak extends Karyawan {
  KaryawanKontrak(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print('$nama bekerja pada proyek spesifik sebagai $peran.');
  }
}

// Mixin Kinerja
mixin Kinerja {
  int produktivitas = 0;
  DateTime lastUpdate = DateTime.now().subtract(Duration(days: 30));

  void updateProduktivitas(int nilai) {
    DateTime now = DateTime.now();
    if (now.difference(lastUpdate).inDays >= 30) {
      produktivitas = (produktivitas + nilai).clamp(0, 100);
      lastUpdate = now;
      print('Produktivitas diperbarui menjadi $produktivitas.');
    } else {
      print("Produktivitas hanya bisa diperbarui setiap 30 hari.");
    }
  }
}

// Karyawan Manager dengan aturan produktivitas minimal 85
class Manager extends Karyawan with Kinerja {
  Manager(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    if (produktivitas >= 85) {
      print('$nama bekerja dengan produktivitas tinggi sebagai $peran.');
    } else {
      print('$nama tidak memenuhi standar produktivitas minimal.');
    }
  }
}

// Kelas Perusahaan dengan pembatasan karyawan aktif
class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  static const int maxKaryawanAktif = 20;

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < maxKaryawanAktif) {
      karyawanAktif.add(karyawan);
      print('${karyawan.nama} berhasil ditambahkan ke karyawan tetap.');
    } else {
      print("Tidak dapat menambahkan karyawan. Batas maksimal tercapai.");
    }
  }

  void karyawanResign(Karyawan karyawan) {
    if (karyawanAktif.remove(karyawan)) {
      karyawanNonAktif.add(karyawan);
      print('${karyawan.nama} telah resign dan menjadi karyawan non-aktif.');
    } else {
      print('${karyawan.nama} tidak ditemukan di daftar karyawan aktif.');
    }
  }
}

// Kelas Proyek dengan fase
class Proyek {
  FaseProyek fase = FaseProyek.Perencanaan;
  List<Karyawan> timProyek = [];
  DateTime tanggalMulai;

  Proyek(this.tanggalMulai);

  void tambahKaryawanKeTim(Karyawan karyawan) {
    timProyek.add(karyawan);
    print('${karyawan.nama} ditambahkan ke tim proyek.');
  }

  void lanjutKeFaseBerikutnya() {
    if (fase == FaseProyek.Perencanaan && timProyek.length >= 5) {
      fase = FaseProyek.Pengembangan;
      print("Proyek telah memasuki fase Pengembangan.");
    } else if (fase == FaseProyek.Pengembangan &&
        DateTime.now().difference(tanggalMulai).inDays > 45) {
      fase = FaseProyek.Evaluasi;
      print("Proyek telah memasuki fase Evaluasi.");
    } else {
      print("Syarat untuk melanjutkan ke fase berikutnya belum terpenuhi.");
    }
  }
}

// Implementasi contoh
void main() {
  // Membuat produk digital
  var produk1 =
      ProdukDigital('Sistem Otomasi Jaringan', 250000, 'NetworkAutomation', 60);
  produk1.terapkanDiskon();
  print('Harga setelah diskon: ${produk1.harga}');

  // Menambahkan karyawan
  var karyawan1 = KaryawanTetap('Alice', umur: 30, peran: 'Developer');
  var karyawan2 = Manager('Bob', umur: 40, peran: 'Manager');
  karyawan2.updateProduktivitas(90);

  // Membuat perusahaan
  var perusahaan = Perusahaan();
  perusahaan.tambahKaryawan(karyawan1);
  perusahaan.tambahKaryawan(karyawan2);

  // Membuat proyek
  var proyek = Proyek(DateTime.now().subtract(Duration(days: 50)));
  proyek.tambahKaryawanKeTim(karyawan1);
  proyek.tambahKaryawanKeTim(karyawan2);
  proyek.lanjutKeFaseBerikutnya(); // Harus memenuhi syarat untuk beralih fase
}
