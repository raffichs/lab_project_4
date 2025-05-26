import 'package:lab_project_4/models/clothing_model.dart';
import 'package:lab_project_4/pages/home_page.dart';
import 'package:lab_project_4/services/clothing_service.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final int id;
  const EditPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final name = TextEditingController();
  final price = TextEditingController();
  final category = TextEditingController();
  final brand = TextEditingController();
  final sold = TextEditingController();
  final rating = TextEditingController();
  final stock = TextEditingController();
  final material = TextEditingController();
  final yearList = [2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025];
  late int yearReleased;
  bool _isDataLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Clothing"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _clothingWidget(),
      ),
    );
  }

  Widget _clothingWidget() {
    return FutureBuilder(
      future: ClothingService.getClothingById(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          if (!_isDataLoaded) {
            _isDataLoaded = true;
            Clothing clothing = Clothing.fromJson(snapshot.data!["data"]);
            name.text = clothing.name!;
            price.text = clothing.price!.toString();
            category.text = clothing.category!;
            brand.text = clothing.brand!;
            material.text = clothing.material!;
            sold.text = clothing.sold!.toString();
            stock.text = clothing.stock!.toString();
            rating.text = clothing.rating!.toString();
            yearReleased = clothing.yearReleased!;
          }
          return _clothingEditForm(context);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothingEditForm(BuildContext context) {
    return ListView(
      children: [
        _textField(name, "Name"),
        _textField(price, "Price"),
        _textField(category, "Category"),
        _textField(brand, "Brand"),
        _textField(material, "Material"),
        _textField(sold, "Sold"),
        _textField(stock, "Stock"),
        _textField(rating, "Rating"),
        const SizedBox(height: 12),
        const Text("Year Released",
            style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<int>(
          value: yearReleased,
          isExpanded: true,
          onChanged: (int? value) {
            setState(() {
              yearReleased = value!;
            });
          },
          items: yearList.map((int value) {
            return DropdownMenuItem(value: value, child: Text("$value"));
          }).toList(),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            _updateClothing(context);
          },
          child: const Text("Update Clothing",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _textField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Future<void> _updateClothing(BuildContext context) async {
    try {
      int? priceInt = int.tryParse(price.text.trim());
      int? soldInt = int.tryParse(sold.text.trim());
      int? stockInt = int.tryParse(stock.text.trim());
      double? ratingDouble = double.tryParse(rating.text.trim());
      if (priceInt == null ||
          soldInt == null ||
          stockInt == null ||
          ratingDouble == null) {
        throw Exception("Input tidak valid.");
      }
      Clothing updatedClothing = Clothing(
        id: widget.id,
        name: name.text.trim(),
        price: priceInt,
        category: category.text.trim(),
        brand: brand.text.trim(),
        material: material.text.trim(),
        sold: soldInt,
        stock: stockInt,
        rating: ratingDouble,
        yearReleased: yearReleased,
      );
      final response = await ClothingService.updateClothing(updatedClothing);
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Clothing ${updatedClothing.name} updated")),
        );
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } else {
        throw Exception(response["message"]);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $error")),
      );
    }
  }
}
