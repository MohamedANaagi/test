import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/cubit/app_cubit/app_cubit.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getAllFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: const Text(' My Favourites'
                ,style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),

              ),
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
            ),
            body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://student.valuxapps.com/storage/uploads/categories/16893929290QVM1.modern-devices-isometric-icons-collection-with-sixteen-isolated-images-computers-periphereals-variou.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: state is GetFavouritesLoading || cubit.favouriteModel == null
                ? const Center(child: CircularProgressIndicator())
                : state is GetFavouritesError
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Error while getting favourites"),
                  TextButton(
                    onPressed: () {
                      AppCubit.get(context).getAllFavourites();
                    },
                    child: const Text("Reload"),
                  ),
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: cubit.favouriteModel!.data!.favouriteData!.length,
                itemBuilder: (context, index) {
                  final product = cubit.favouriteModel!.data!.favouriteData![index].product!;
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product.image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple, // White text for visibility on background
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  product.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${product.price.toString()} EGP",
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (product.discount != null)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                                  child: Center(
                                    child: Text(
                                      "${product.discount}%",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              IconButton(
                                onPressed: () {
                                  cubit.changeProductFavourite(productId: product.id!);
                                },
                                icon: Icon(
                                  cubit.favMap[product.id]! ? Icons.favorite : Icons.favorite_outline,
                                  color: cubit.favMap[product.id]! ? Colors.red : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
