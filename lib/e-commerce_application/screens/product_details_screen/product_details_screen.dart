import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:we_session1/e-commerce_application/screens/cart_screen/cart_screen.dart';
import 'package:we_session1/e-commerce_application/shared/cubit/app_cubit/app_cubit.dart';
import '../../model/home_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Products product;
  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Details",
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: PageView.builder(
                        controller: _controller,
                        onPageChanged: (value) {},
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.product.images![index],
                          );
                        },
                        itemCount: widget.product.images!.length,
                      ),
                    ),
                    widget.product.discount! != 0
                        ? Align(
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
                            "${widget.product.discount}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                        : const SizedBox(),
                  ],
                ),
                Center(
                  child: SmoothPageIndicator(
                    controller: _controller, // PageController
                    count: widget.product.images!.length,
                    effect: WormEffect(), // your preferred effect
                    onDotClicked: (index) {},
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Text(
                    widget.product.name!,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.product.description!,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "${widget.product.price!.toString()} EGP",
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: BlocListener<AppCubit, AppState>(
                      listener: (context, state) {
                        if (state is CartErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }

                        if (state is CartUpdatedState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cart updated successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<AppCubit, AppState>(
                        builder: (context, state) {
                          var isInCart = context.read<AppCubit>().isInCart(widget.product.id!);
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              minimumSize: const Size(double.infinity, 55.0),
                            ),
                            onPressed: () {
                              context.read<AppCubit>().toggleCart(widget.product.id!);
                            },
                            child: Text(
                              isInCart ? "Remove from cart" : "Add to cart",
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.deepPurple,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
