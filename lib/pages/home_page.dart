import 'package:lab_project_4/models/clothing_model.dart';
import 'package:lab_project_4/pages/create_page.dart';
import 'package:lab_project_4/pages/detail_page.dart';
import 'package:lab_project_4/pages/edit_page.dart';
import 'package:lab_project_4/services/clothing_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pakaian"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _clothesContainer(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => const CreatePage(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _clothesContainer() {
    return FutureBuilder(
      future: ClothingService.getClothes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          ClothingModel response = ClothingModel.fromJson(snapshot.data!);
          return _clothingList(context, response.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothingList(BuildContext context, List<Clothing> clothes) {
    if (clothes.isEmpty) {
      return const Center(child: Text("No clothes found."));
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: clothes.length,
      itemBuilder: (context, index) {
        final clothing = clothes[index];
        return Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DetailPage(id: clothing.id!),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          clothing.name!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 2),
                          Text(
                            "${clothing.rating!}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text("Rp${clothing.price!},00",
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text(clothing.category!,
                      style: const TextStyle(color: Colors.grey)),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EditPage(id: clothing.id!),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit,
                            color: Colors.deepPurple, size: 20),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        onPressed: () {
                          _delete(clothing.id!);
                        },
                        icon: const Icon(Icons.delete,
                            color: Colors.red, size: 20),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _delete(int id) async {
    try {
      final response = await ClothingService.deleteClothing(id);
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Clothing Removed")),
        );
        setState(() {});
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
