import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_session1/e-commerce_application/model/cart_model.dart';
import 'package:we_session1/e-commerce_application/model/home_model.dart';
import 'package:we_session1/e-commerce_application/shared/cubit/app_cubit/app_cubit.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Products> products = context.read<AppCubit>().allProducts ?? []; // Handle null case
    var cartItems = context.read<AppCubit>().getCartItems(products); // Fetch all cart items

    return Scaffold(
      appBar: AppBar(
          title: const Text('My Cart'
            ,style: TextStyle(fontSize: 24.0,),
          ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: cartItems.isNotEmpty
          ? ListView.separated(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          var product = cartItems[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product.image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${product.price} EGP",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<AppCubit>().toggleCart(product.id!); // Remove item from cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Product removed from cart!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      )
          : const Center(child: Text("Your cart is empty", style: TextStyle(fontSize: 20))),
    );
  }
}
