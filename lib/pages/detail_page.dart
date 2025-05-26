import 'package:lab_project_4/models/clothing_model.dart';
import 'package:lab_project_4/services/clothing_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final int id;
  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clothing Detail"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _clothingDetail(),
      ),
    );
  }

  Widget _clothingDetail() {
    return FutureBuilder(
      future: ClothingService.getClothingById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          Clothing clothing = Clothing.fromJson(snapshot.data!["data"]);
          return _clothingWidget(clothing);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothingWidget(Clothing clothing) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${clothing.name!}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Category: ${clothing.category!}",
                style: const TextStyle(fontSize: 16)),
            Text("Price: Rp${clothing.price!}",
                style: const TextStyle(fontSize: 16)),
            Text("Brand: ${clothing.brand!}",
                style: const TextStyle(fontSize: 16)),
            Text("Stock: ${clothing.stock!}",
                style: const TextStyle(fontSize: 16)),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text("${clothing.rating!} / 5.0",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            Text("Sold: ${clothing.sold!}",
                style: const TextStyle(fontSize: 16)),
            Text("Material: ${clothing.material!}",
                style: const TextStyle(fontSize: 16)),
            Text("Year Released: ${clothing.yearReleased!}",
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
