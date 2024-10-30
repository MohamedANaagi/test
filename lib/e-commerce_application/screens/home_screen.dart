import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_session1/e-commerce_application/screens/product_details_screen/product_details_screen.dart';
import 'package:we_session1/e-commerce_application/shared/cubit/app_cubit/app_cubit.dart';

import '../model/home_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if(state is ChangeProductFavouriteError){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                  content: Text(
                "This product cannot be added in favourite now",
              ),),
            );
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          if (state is GetHomeDataLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetHomeDataError) {
            return Center(
              child: Column(
                children: [
                  Text(
                    "Error while getting home data",
                  ),
                  TextButton(
                    onPressed: () {
                      AppCubit.get(context).getHomeData();
                    },
                    child: Text(
                      "Reload",
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    items: makeSliderItems(cubit.homeModel!.data!.banners!),
                    options: CarouselOptions(
                      height: 200,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    "All Products",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            childAspectRatio: 10/15
                          ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_){
                              return ProductDetailsScreen(product: cubit.homeModel!.data!.products![index]) ;
                              }),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        cubit.homeModel!.data!.products![index]
                                            .image!,
                                      ),
                                      cubit.homeModel!.data!.products![index].discount! != 0 ? Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 40,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${cubit.homeModel!.data!.products![index].discount}%",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ): const SizedBox(),

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    cubit.homeModel!.data!.products![index].name!,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            cubit.homeModel!.data!.products![index]
                                                .price!
                                                .toString(),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          cubit.homeModel!.data!.products![index].discount! != 0 ? Text(
                                            cubit.homeModel!.data!.products![index]
                                                .oldPrice!
                                                .toString(),
                                            style:const  TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ):const SizedBox(),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          cubit.changeProductFavourite(productId: cubit.homeModel!.data!.products![index].id!);
                                        },
                                        icon:  Icon(
                                          cubit.favMap[cubit.homeModel!.data!.products![index].id]!?
                                          Icons.favorite_outlined:Icons.favorite_outline,
                                          color: cubit.favMap[cubit.homeModel!.data!.products![index].id]!? Colors.red:Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: cubit.homeModel!.data!.products!.length,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> makeSliderItems(List<Banners> allBanners) {
    List<Widget> allImages = [];
    for (var element in allBanners) {
      allImages.add(
        Image.network(element.image ??
            "https://c8.alamy.com/comp/MR0G79/random-pictures-MR0G79.jpg"),
      );
    }
    return allImages;
  }
}
