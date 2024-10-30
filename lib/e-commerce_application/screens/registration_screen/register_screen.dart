import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_session1/e-commerce_application/screens/login_screen/login_screen.dart';
import 'package:we_session1/e-commerce_application/screens/main_layout/main_layout.dart';
import 'package:we_session1/e-commerce_application/shared/cubit/auth_cubit/auth_cubit.dart';

import '../../shared/network/local/cache_helper/cache_helper.dart';
import '../../shared/widgets/my_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFECE9EA), Color(0xFF5D4626)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 11,
                ),
                Text(
                  "REGISTER",
                  style: GoogleFonts.manrope(
                    textStyle: const TextStyle(
                      fontSize: 38.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Create an account",
                  style: GoogleFonts.manrope(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                MyTextFormField(
                  controller: _usernameController,
                  title: "Name",
                  labelText: "Name",
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                MyTextFormField(
                  controller: _emailController,
                  title: "Email",
                  labelText: "Email",
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                MyTextFormField(
                  controller: _passwordController,
                  title: "Password",
                  labelText: "Password",
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                  ),
                  isPassword: true,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                MyTextFormField(
                  controller: _phoneNumberController,
                  title: "Phone",
                  labelText: "Phone",
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  //isPassword: true,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) async {
                    if (state is RegisterWithError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(state.message),
                        ),
                      );
                    }
                    if (state is RegisterSuccessfully) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(state.model.message!),
                        ),
                      );
                      await CacheHelper.storeInCache(
                        "token",
                        state.model.data!.token!,
                      );
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_)=>MainLayout()));
                    }
                  },
                  builder: (context, state) {
                    var cubit = AuthCubit.get(context);
                    if (state is RegisterLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        minimumSize: const Size(double.infinity, 55.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        cubit.register(
                            username: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            phoneNumber: _phoneNumberController.text

                          //confirmPassword: _confirmPasswordController.text,
                        );
                      },
                      child: const Text(
                        "REGISTER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 24.0,
                          fontWeight:FontWeight.bold
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NewLoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const  SizedBox(height: 50.0,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}