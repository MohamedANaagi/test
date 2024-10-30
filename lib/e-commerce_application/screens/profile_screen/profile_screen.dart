import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_session1/e-commerce_application/shared/cubit/app_cubit/app_cubit.dart';

import '../../shared/cubit/app_cubit/app_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' My Profile'
        ,style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),

        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is GetUserDataSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("User data retrieved successfully"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is UpdateUserDataSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Profile updated successfully"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is LogoutSuccessfully) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          if (state is GetUserDataLoading || cubit.user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Populate the controllers with the user data
          _usernameController.text = cubit.user!.data!.name!;
          _emailController.text = cubit.user!.data!.email!;
          _phoneController.text = cubit.user!.data!.phone!;

          return Padding(
            padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20.0),

                // Circular Avatar in the center
                Center(
                  child: CircleAvatar(
                    radius: 55.0,
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/originals/e1/67/4d/e1674d71e7e6d6020bcc7612aff837cd.jpg', // Replace with actual user avatar URL or a placeholder
                    ),
                    backgroundColor: Colors.grey[300], // Background color for avatar
                  ),
                ),

                const SizedBox(height: 20.0),

                // Username field
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40.0),

                // Update Profile button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[500],
                    minimumSize: const Size(double.infinity, 55.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    cubit.updateUserData(
                      username: _usernameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                    );
                  },
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Logout button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 55.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    cubit.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),)
          );
        },
      ),
    );
  }
}
