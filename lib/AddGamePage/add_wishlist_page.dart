import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import '../Providers/wishlist_provider.dart';
import '../Providers/categorie_provider.dart';
import '../Providers/plateforme_provider.dart';
import '../Providers/wishlist_categorie_provider.dart';
import '../Providers/wishlist_plateforme_provider.dart';
import '../Models/wishlist_model.dart';
import '../Models/categorie_model.dart';
import '../Models/plateforme_model.dart';

class AddWishlistPage extends StatefulWidget {
  const AddWishlistPage({super.key});

  @override
  _AddWishlistPageState createState() => _AddWishlistPageState();
}

class _AddWishlistPageState extends State<AddWishlistPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  File? _newImageFile;
  List<int> _selectedCategoryIds = [];
  List<Categorie> _allCategories = [];
  List<int> _selectedPlatformIds = [];
  List<Plateforme> _allPlatforms = [];
  late String _currentDate;
  int _selectedPriority = 1;

  final Map<int, String> _priorityOptions = {
    1: 'A joué un jour',
    2: 'À découvrir',
    3: 'Intéressant',
    4: 'Prioritaire',
    5: 'À faire absolument',
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _currentDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    _loadCategoriesAndPlatforms();
  }

  void _loadCategoriesAndPlatforms() async {
    final allCategories = await CategorieProvider().getAllCategories();
    final allPlatforms = await PlateformeProvider().getAllPlatforms();

    setState(() {
      _allCategories = allCategories;
      _allPlatforms = allPlatforms;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (pickedFile != null) {
      setState(() {
        _newImageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _saveImageToDocuments() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageFileName = p.basename(_newImageFile!.path);
    final savedImagePath = '${appDir.path}/$imageFileName';

    await _newImageFile!.copy(savedImagePath);
    return savedImagePath;
  }

  Future<void> _openCategorySelector() async {
    List<int> selectedCategories = List<int>.from(_selectedCategoryIds);
    TextEditingController newCategoryController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Sélectionner les catégories'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ..._allCategories.map((category) {
                      return CheckboxListTile(
                        title: Text(category.name),
                        value: selectedCategories.contains(category.id),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedCategories.add(category.id!);
                            } else {
                              selectedCategories.remove(category.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                    const Divider(),
                    TextField(
                      controller: newCategoryController,
                      decoration: const InputDecoration(
                        labelText: 'Nouvelle catégorie',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (newCategoryController.text.isNotEmpty) {
                      final newCategoryId = await CategorieProvider().insertCategory(newCategoryController.text);
                      setState(() {
                        _allCategories.add(Categorie(id: newCategoryId, name: newCategoryController.text));
                        selectedCategories.add(newCategoryId);
                      });
                    }
                    Navigator.pop(context, selectedCategories);
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    ).then((updatedCategories) {
      if (updatedCategories != null) {
        setState(() {
          _selectedCategoryIds = updatedCategories;
        });
      }
    });
  }

  Future<void> _openPlatformSelector() async {
    List<int> selectedPlatforms = List<int>.from(_selectedPlatformIds);
    TextEditingController newPlatformController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Sélectionner les plateformes'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ..._allPlatforms.map((platform) {
                      return CheckboxListTile(
                        title: Text(platform.name),
                        value: selectedPlatforms.contains(platform.id),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedPlatforms.add(platform.id!);
                            } else {
                              selectedPlatforms.remove(platform.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                    const Divider(),
                    TextField(
                      controller: newPlatformController,
                      decoration: const InputDecoration(
                        labelText: 'Nouvelle plateforme',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (newPlatformController.text.isNotEmpty) {
                      final newPlatformId = await PlateformeProvider().insertPlatform(newPlatformController.text);
                      setState(() {
                        _allPlatforms.add(Plateforme(id: newPlatformId, name: newPlatformController.text));
                        selectedPlatforms.add(newPlatformId);
                      });
                    }
                    Navigator.pop(context, selectedPlatforms);
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    ).then((updatedPlatforms) {
      if (updatedPlatforms != null) {
        setState(() {
          _selectedPlatformIds = updatedPlatforms;
        });
      }
    });
  }

  void _saveWishlist() async {
    if (_formKey.currentState!.validate()) {
      String imagePath = '';
      if (_newImageFile != null) {
        imagePath = await _saveImageToDocuments();
      }

      Wishlist newWishlist = Wishlist(
        gameTitle: _titleController.text,
        priority: _selectedPriority,
        dateAdded: _currentDate,
        imagePath: imagePath,
      );

      final wishlistId = await WishlistProvider().insertWishlist(newWishlist);

      await WishlistCategorieProvider().updateWishlistCategories(wishlistId, _selectedCategoryIds);
      await WishlistPlateformeProvider().updateWishlistPlatforms(wishlistId, _selectedPlatformIds);

      Navigator.pop(context);
    }
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Container(
          width: 150,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _newImageFile != null
                ? Image.file(
              _newImageFile!,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.add_photo_alternate, size: 80, color: Colors.grey),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: InkWell(
            onTap: _pickImage,
            child: const Icon(
              Icons.edit,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter à la Wishlist'),
      ),
      body: _allCategories.isEmpty || _allPlatforms.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre du jeu'),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un titre' : null,
              ),
              const SizedBox(height: 20),
              _buildImage(),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _selectedPriority,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedPriority = newValue!;
                  });
                },
                items: _priorityOptions.entries.map<DropdownMenuItem<int>>((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Priorité'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Date d\'ajout: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_currentDate),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Catégories'),
              Wrap(
                spacing: 8.0,
                children: _allCategories
                    .where((category) => _selectedCategoryIds.contains(category.id))
                    .map((category) => Chip(label: Text(category.name)))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: _openCategorySelector,
                child: const Text('Sélectionner les catégories'),
              ),
              const SizedBox(height: 20),
              const Text('Plateformes'),
              Wrap(
                spacing: 8.0,
                children: _allPlatforms
                    .where((platform) => _selectedPlatformIds.contains(platform.id))
                    .map((platform) => Chip(label: Text(platform.name)))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: _openPlatformSelector,
                child: const Text('Sélectionner les plateformes'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveWishlist,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
