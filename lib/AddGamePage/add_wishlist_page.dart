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
              backgroundColor: const Color.fromARGB(255, 26, 26, 29),
              title: const Text(
                'Sélectionner les catégories',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ..._allCategories.map((category) {
                      return CheckboxListTile(
                        activeColor: const Color.fromARGB(255, 128, 0, 128),
                        checkColor: Colors.white,
                        title: Text(
                          category.name,
                          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        value: selectedCategories.contains(category.id),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedCategories.add(category.id!);
                            }
                            else {
                              selectedCategories.remove(category.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                    const Divider(color: Colors.white),
                    TextField(
                      controller: newCategoryController,
                      decoration: const InputDecoration(
                        labelText: 'Nouvelle catégorie',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
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
                  child: const Text('Enregistrer', style: TextStyle(color: Color.fromARGB(255, 128, 0, 128))),
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
              backgroundColor: const Color.fromARGB(255, 26, 26, 29),
              title: const Text(
                'Sélectionner les plateformes',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ..._allPlatforms.map((platform) {
                      return CheckboxListTile(
                        activeColor: const Color.fromARGB(255, 128, 0, 128),
                        checkColor: Colors.white,
                        title: Text(
                          platform.name,
                          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        value: selectedPlatforms.contains(platform.id),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedPlatforms.add(platform.id!);
                            }
                            else {
                              selectedPlatforms.remove(platform.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                    const Divider(color: Colors.white),
                    TextField(
                      controller: newPlatformController,
                      decoration: const InputDecoration(
                        labelText: 'Nouvelle plateforme',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
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
                  child: const Text('Enregistrer', style: TextStyle(color: Color.fromARGB(255, 128, 0, 128))),
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

      Navigator.pop(context, true);
    }
  }


  Widget _buildImage() {
    return Stack(
      children: [
        Container(
          width: 150,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 128, 0, 128)),
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
              color: Colors.purple,
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
        title: const Text('Ajouter à la Wishlist', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        backgroundColor: const Color.fromARGB(255, 26, 26, 29),
      ),
      body: _allCategories.isEmpty || _allPlatforms.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre du jeu',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
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
                    child: Text(entry.value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Priorité',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                dropdownColor: const Color.fromARGB(255, 26, 26, 29),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Date d\'ajout: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(_currentDate, style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Catégories', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: _allCategories
                    .where((category) => _selectedCategoryIds.contains(category.id))
                    .map((category) => Chip(
                  label: Text(category.name),
                  backgroundColor: const Color.fromARGB(255, 128, 0, 128),
                  labelStyle: const TextStyle(color: Colors.white),
                ))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: _openCategorySelector,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 26, 26, 29),
                  side: const BorderSide(color: Color.fromARGB(255, 128, 0, 128)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Sélectionner les catégories', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              const Text('Plateformes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: _allPlatforms
                    .where((platform) => _selectedPlatformIds.contains(platform.id))
                    .map((platform) => Chip(
                  label: Text(platform.name),
                  backgroundColor: const Color.fromARGB(255, 128, 0, 128),
                  labelStyle: const TextStyle(color: Colors.white),
                ))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: _openPlatformSelector,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 26, 26, 29),
                  side: const BorderSide(color: Color.fromARGB(255, 128, 0, 128)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Sélectionner les plateformes', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveWishlist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 128, 0, 128),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
