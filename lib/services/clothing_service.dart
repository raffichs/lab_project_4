import 'dart:convert'; // <- Untuk melakukan encode dan decode JSON
import 'package:lab_project_4/models/clothing_model.dart';

// Supaya dapat mengirimkan HTTP request
import 'package:http/http.dart' as http;

class ClothingService {
  // Buat menyimpan URL dari API yg akan digunakan supaya ga perlu nulis ulang tiap mau manggil
  static const url =
      "https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes";

  /*
    Kalau temen-temen liat di bawah, semua method itu punya return type Future<Map<String, dynamic>>
    Penjelasan:
    - Future<...>: Menandakan bahwa method ini berjalan secara asynchronous
    - Map<String, dynamic>: Return value berupa JSON (key String, value bisa tipe apa saja).
  */

  // Method buat mengambil seluruh data pakaian
  static Future<Map<String, dynamic>> getClothes() async {
    // Mengirim GET request ke url, kemudian disimpan ke dalam variabel "response"
    final response = await http.get(Uri.parse(url));

    /*
      Hasil dari get request yg disimpan ke variabel "response" itu menyimpan banyak hal,
      seperti statusCode, contentLength, headers, data, dsb.
      Nah, kita cuma mau nge-return datanya doang. Kita bisa mengakses "data"-nya aja dengan
      mengetikkan "response.data"

      Sebelum kita return, kita perlu mengubah JSON menjadi Map<String, dynamic> agar 
      bisa diproses di Dart. Kita bisa mengubahnya menggunakan fungsi jsonDecode().
    */
    return jsonDecode(response.body);
  }

  // Method buat menambahkan produk baru
  static Future<Map<String, dynamic>> addClothing(Clothing newClothing) async {
    /* 
      Mengirim POST request ke url.
      Ketika kita mengirim POST request, kita membutuhkan request body.
      Selain itu, kita juga perlu memberi tahu jenis dari request body-nya itu.

      Karena kita ingin mengirimkan data berupa teks, 
      maka pada bagian headers: Content-Type kita isi menjadi "application/json"

      Pada bagian request body, kita akan mengisi request body dengan data yang telah diisi tadi.
      Kita bisa memanfaatkan parameter "Clothing newClothing" untuk mengisinya.
      Kita juga perlu mengubahnya ke dalam bentuk JSON supaya bisa dikirimkan ke API.

      Terakhir, hasil dari POST request disimpan ke dalam variabel "response"
    */
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newClothing),
    );

    /*
      Hasil dari get request yg disimpan ke variabel "response" itu menyimpan banyak hal,
      seperti statusCode, contentLength, headers, data, dsb.
      Nah, kita cuma mau nge-return datanya doang. Kita bisa mengakses "data"-nya aja dengan
      mengetikkan "response.data"

      Sebelum kita return, kita perlu mengubah JSON menjadi Map<String, dynamic> agar 
      bisa diproses di Dart. Kita bisa mengubahnya menggunakan fungsi jsonDecode().
    */
    return jsonDecode(response.body);
  }

  // Method buat mengambil data pakaian secara detail berdasarkan id
  static Future<Map<String, dynamic>> getClothingById(int id) async {
    // Mengirim GET request ke url, kemudian disimpan ke dalam variabel "response"
    final response = await http.get(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }

  // Method buat mengedit data pakaian berdasarkan id
  static Future<Map<String, dynamic>> updateClothing(
    Clothing updatedClothing,
  ) async {
    /* 
      Mengirim PUT request ke url.
      Ketika kita mengirim PUT request, kita membutuhkan request body.
      Selain itu, kita juga perlu memberi tahu jenis dari request body-nya itu.

      Karena kita ingin mengirimkan data berupa teks, 
      maka pada bagian headers: Content-Type kita isi menjadi "application/json"

      Pada bagian request body, kita akan mengisi request body dengan data yang kita ubah tadi.
      Kita bisa memanfaatkan parameter "Clothing updatedClothing" untuk mengisinya.
      Kita juga perlu mengubahnya ke dalam bentuk JSON supaya bisa dikirimkan ke API.
      
      Terakhir, hasil dari POST request disimpan ke dalam variabel "response"
    */

    final response = await http.put(
      Uri.parse("$url/${updatedClothing.id}"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedClothing),
    );

    /*
      Hasil dari get request yg disimpan ke variabel "response" itu menyimpan banyak hal,
      seperti statusCode, contentLength, headers, data, dsb.
      Nah, kita cuma mau nge-return datanya doang. Kita bisa mengakses "data"-nya aja dengan
      mengetikkan "response.data"

      Sebelum kita return, kita perlu mengubah JSON menjadi Map<String, dynamic> agar 
      bisa diproses di Dart. Kita bisa mengubahnya menggunakan fungsi jsonDecode().
    */
    return jsonDecode(response.body);
  }

  // Method buat menghapus data pakaian berdasarkan id
  static Future<Map<String, dynamic>> deleteClothing(int id) async {
    // Mengirim DELETE request ke url, kemudian disimpan ke dalam variabel "response"
    final response = await http.delete(Uri.parse("$url/$id"));

    /*
      Hasil dari get request yg disimpan ke variabel "response" itu menyimpan banyak hal,
      seperti statusCode, contentLength, headers, data, dsb.
      Nah, kita cuma mau nge-return datanya doang. Kita bisa mengakses "data"-nya aja dengan
      mengetikkan "response.data"

      Sebelum kita return, kita perlu mengubah JSON menjadi Map<String, dynamic> agar 
      bisa diproses di Dart. Kita bisa mengubahnya menggunakan fungsi jsonDecode().
    */
    return jsonDecode(response.body);
  }
}
