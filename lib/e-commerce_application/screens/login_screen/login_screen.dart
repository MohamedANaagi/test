import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_session1/e-commerce_application/screens/main_layout/main_layout.dart';
import 'package:we_session1/e-commerce_application/screens/registration_screen/register_screen.dart';
import 'package:we_session1/e-commerce_application/shared/cubit/auth_cubit/auth_cubit.dart';
import 'package:we_session1/e-commerce_application/shared/network/local/cache_helper/cache_helper.dart';

import '../../shared/widgets/my_text_form_field.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({super.key});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


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
                  height: MediaQuery.of(context).size.height / 6,
                ),
                Text(
                  "LOG IN",
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
                  "Log in to continue",
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
                  controller: _emailController,
                  title: "Username",
                  labelText: "Username",
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                 // textColor: Colors.white,
                //  labelColor: Colors.white54,
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
                  //textColor: Colors.white,
                  //labelColor: Colors.white54,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) async {
                    if (state is LoginWithError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                      content: Text(state.message),
                        ),
                      );
                    }
                    if (state is LoginSuccessfully) {
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
                          context, MaterialPageRoute(builder: (_) => MainLayout()));
                    }
                  },
                  builder: (context, state) {
                    var cubit = AuthCubit.get(context);
                    if (state is LoginLoading) {
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
                        cubit.login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      },
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don’t have an account?",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24.0
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0
                        ),
                      ),
                    ),
                  ],
                ),
               const SizedBox(height: 180.0,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
