// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Authentication extends ConsumerStatefulWidget {
  const Authentication({super.key});
  @override
  ConsumerState<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends ConsumerState<Authentication> {
  final formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign in to your account',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: SvgPicture.asset(
                'asset/ils/undraw_completed_tasks_vs6q.svg',
                width: 100,
              ),
            ),
            const SizedBox(height: 50),
            Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      TextFormField(
                        style: GoogleFonts.quicksand(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                          labelStyle: GoogleFonts.quicksand(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: obscurePassword,
                        style: GoogleFonts.quicksand(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                          suffixIcon: Icon(Icons.visibility_off_rounded),
                          labelStyle: GoogleFonts.quicksand(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              fixedSize: MaterialStatePropertyAll(Size(
                                  MediaQuery.of(context).size.width * 0.8,
                                  45))),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          SizedBox(width: 4),
                          Text('Sign up',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary))
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
