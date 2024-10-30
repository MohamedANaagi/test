import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String labelText;
  final Icon prefixIcon;
  final bool isPassword;

  const MyTextFormField({
    Key? key,
    required this.title,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool isObsecure = false;
  @override
  void initState() {
    super.initState();
    isObsecure = widget.isPassword; //true
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.manrope(
            textStyle: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: isObsecure,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black,
                ),
              ),
              labelText: widget.labelText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isObsecure = !isObsecure;
                        });
                      },
                      icon: Icon(
                        isObsecure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ))
                  : null),
        ),
      ],
    );
  }
}
