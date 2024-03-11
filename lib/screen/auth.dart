// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qeasily/widget/notification.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin, Ui {
  late AnimationController _controller;

  final _formKey = GlobalKey<FormState>();

  bool showPassword = false, isLoading = false;
  bool rememberMe = true;
  String? email, password;

  LocalNotification? notification;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _notify(String message, {int delay = 5, bool? loading}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });
    return await showNotification(_controller, delay);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(userAuthProvider);
    return LayoutBuilder(
        builder: (context, constraints) => Scaffold(
              body: stackWithNotifier([
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        spacer(y: 70),
                        SvgPicture.asset(
                          'asset/ils/undraw_education_f8ru.svg',
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        spacer(y: 20),
                        Text('Login in to your Account', style: medium00),
                        spacer(y: 80),
                        // auth.when(
                        //     data: (data) => Center(child: Text('$data')),
                        //     error: (_, __) => Text('$_'),
                        //     loading: () => Text('Loading ...')),
                        Form(
                            key: _formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    onChanged: (value) => email = value,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Field is required'
                                            : null,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.mail_rounded),
                                        // suffixIcon: Icon(Icons.),
                                        labelText: 'Email',
                                        labelStyle: small00,
                                        border: OutlineInputBorder(),
                                        isDense: true),
                                  ),
                                  spacer(y: 15),
                                  TextFormField(
                                    onChanged: (value) => password = value,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Field is required'
                                            : null,
                                    obscureText: showPassword,
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon: Icon(Icons.lock_outlined),
                                        suffixIcon: GestureDetector(
                                            onTap: () => setState(() =>
                                                showPassword = !showPassword),
                                            child: Icon(showPassword
                                                ? Icons.visibility_off
                                                : Icons.visibility_rounded)),
                                        labelStyle: small00,
                                        border: OutlineInputBorder(),
                                        isDense: true),
                                  ),
                                  spacer(y: 20),
                                  Material(
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      overlayColor:
                                          MaterialStatePropertyAll(blue1),
                                      onTap: () async {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          _notify('Authenticating $email',
                                              loading: true);
                                          await ref
                                              .read(userAuthProvider.notifier)
                                              .login(email!, password!)
                                              .then((value) {
                                            
                                            _notify(value.$1, loading: false)
                                                .then((_) => (value.$2)
                                                    ? context.go('/home')
                                                    : null);
                                          });

                                          // _notify('$res', loading: false);
                                        }
                                      },
                                      child: Ink(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.92,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            color: blue10,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                            child: isLoading
                                                ? SpinKitThreeInOut(
                                                    color: Colors.white,
                                                    size: 20)
                                                : Text('Login',
                                                    style: medium00)),
                                      ),
                                    ),
                                  ),
                                  spacer(y: 8),
                                  Text('Dont have an account?  Register',
                                      style: small01)
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              ], notification),
            ));
  }
}

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with SingleTickerProviderStateMixin, Ui {
  late AnimationController _controller;
  final formKey = GlobalKey<FormState>();
  bool showPassword = false, showConfirm = false, isLoading = false;

  String? username, email, password, confirmPassword;

  LocalNotification? notification;

  Future<void> _notify(String message, {int delay = 5, bool? loading}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });
    return showNotification(_controller, delay);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? validator(String? value) =>
      value == null || value.isEmpty ? 'This field is required' : null;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
