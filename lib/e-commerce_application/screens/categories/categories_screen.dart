import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/cubit/app_cubit/app_cubit.dart';
import 'package:we_session1/e-commerce_application/screens/home_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final Function(int) onCategoryTap;

  const CategoriesScreen({Key? key, required this.onCategoryTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    cubit.getCategoriesData();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Categories'
            ,style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),
          ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          if (state is GetCategoriesDataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCategoriesDataSuccess) {
            final categories = cubit.categoriesModel?.data?.data ?? [];
            if (categories.isEmpty) {
              return const Center(child: Text('No Categories Available'));
            }

            final backgroundImage = categories[0].image;

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    backgroundImage!,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.3),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryTile(
                        title: category.name ?? '',
                        icon: _getCategoryIcon(category.name),
                        onTap: () {
                          onCategoryTap(0);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is GetCategoriesDataError) {
            return const Center(child: Text('Error loading categories'));
          }

          return const SizedBox();
        },
      ),
    );
  }

  IconData _getCategoryIcon(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'electrionic devices':
        return Icons.devices;
      case 'prevent corona':
        return Icons.coronavirus;
      case 'sports':
        return Icons.sports_soccer;
      case 'lighting':
        return Icons.lightbulb;
      case 'clothes':
        return Icons.shopping_bag;
      case 'groceries':
        return Icons.local_grocery_store_outlined;
      default:
        return Icons.category;
    }
  }
}


class CategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap; // Add a callback for when the tile is tapped

  const CategoryTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap, // Make onTap required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(
          icon,
          size: 35.0,
          color: Colors.green,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Adapt text color for dark backgrounds
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.green,
        ),
        onTap: onTap, // Call the onTap function when the tile is tapped
      ),
    );
  }
}
