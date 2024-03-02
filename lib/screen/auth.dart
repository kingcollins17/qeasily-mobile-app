// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    with SingleTickerProviderStateMixin, UIStyles {
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

  void _handleLogin() async {
    if (isLoading)
      _notify('Please wait ...');
    else if (_formKey.currentState?.validate() ?? false) {
      _notify('Authenticating user ...', loading: true);
      final notifier = ref.read(userAuthProvider.notifier);
      final res = await notifier.login(email: email!, password: password!);
      _notify(res.$2, loading: false)
          .then((value) => res.$1 ? context.go('/home') : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(userAuthProvider);
    return Scaffold(
      // appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: stackWithNotifier([
        SingleChildScrollView(
          child: sb(pad(
            Column(
              children: [
                spacer(y: 50),
                authSymbol(),
                spacer(),
                txt('Sign In', sz: 16),
                spacer(y: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: !isLoading,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your email to Login'
                            : null,
                        onChanged: (value) => email = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          hintText: 'example@gmail.com',
                        ),
                      ),
                      spacer(y: 15),
                      TextFormField(
                        obscureText: showPassword,
                        enabled: !isLoading,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Password is required'
                            : null,
                        onChanged: (value) => password = value,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: GestureDetector(
                            onTap: () =>
                                setState(() => showPassword = !showPassword),
                            child: Icon(!showPassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(),

                          isDense: true,
                          labelText: 'Password',
                          // hintText: 'example',
                        ),
                      ),
                      spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox.adaptive(
                            value: rememberMe,
                            onChanged: (value) => setState(
                                () => rememberMe = value ?? rememberMe),
                          ),
                          // spacer(x: 2),
                          txt('Remember me'),
                        ],
                      ),
                      button(
                          auth.isLoading
                              ? loader(sz: 20, color: Colors.white)
                              : txt('Login', sz: 16, cx: Colors.white),
                          onTap: _handleLogin)
                    ],
                  ),
                ),
                // Align()
                spacer(),
                GestureDetector(
                  onTap: () => context.pushReplacement('/sign-up'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      txt('Dont have an account?'),
                      spacer(),
                      txt('Sign Up', cx: blue1),
                    ],
                  ),
                )
              ],
            ),
          )),
        ),
      ], notification), //stackWithNotifier
    );
  }
}

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with SingleTickerProviderStateMixin, UIStyles {
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

  Future<void> _handleSubmit() async {
    if (isLoading)
      _notify('Please wait ....');
    else if (formKey.currentState?.validate() ?? false) {
      _notify('Creating an account for you', loading: true);
      final notifier = ref.read(userAuthProvider.notifier);
      final res = await notifier.register(
          username: username!, email: email!, password: password!);

      await _notify('${res.message} Please go to Login',
              loading: false, delay: 3)
          .then((value) => res.status ? context.go('/login') : null);
    }
  }

  String? validator(String? value) =>
      value == null || value.isEmpty ? 'This field is required' : null;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(userAuthProvider);
    return Scaffold(
      body: stackWithNotifier([
        SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  spacer(y: 30),
                  authSymbol(),
                  spacer(),
                  txt('Create an Account with us', sz: 16),
                  spacer(y: 40),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) => username = value,
                          enabled: !isLoading,
                          validator: validator,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_2_outlined),
                              border: OutlineInputBorder(),
                              isDense: true,
                              labelText: 'Username'),
                        ),
                        spacer(y: 12),
                        TextFormField(
                          onChanged: (value) => email = value,
                          enabled: !isLoading,
                          validator: validator,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(Icons.email_rounded),
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                        spacer(y: 10),
                        TextFormField(
                          onChanged: (value) => password = value,
                          enabled: !isLoading,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Password is required'
                              : value.length < 8
                                  ? 'Password cannot be less than eight characters'
                                  : null,
                          obscureText: showPassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: Icon(Icons.visibility_rounded),
                            isDense: true,
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                        spacer(y: 10),
                        TextFormField(
                          onChanged: (value) => confirmPassword = value,
                          enabled: !isLoading,
                          validator: (value) => value == null || value.isEmpty
                              ? 'This field is required'
                              : value != password
                                  ? 'Confirm password does not match password'
                                  : null,
                          obscureText: showConfirm,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: Icon(Icons.visibility_rounded),
                            border: OutlineInputBorder(),
                            labelText: 'Confirm Password',
                          ),
                        ),
                        spacer(y: 30),
                        button(
                            auth.isLoading || isLoading
                                ? loader(color: Colors.white, sz: 20)
                                : txt('Create Account', cx: Colors.white),
                            onTap: _handleSubmit),
                        spacer(),
                        GestureDetector(
                          onTap: () => context.pushReplacement('/login'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              txt('Already have an account?'),
                              spacer(),
                              txt('Login', cx: blue1),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ], notification //Stack with Notifier
          ),
    );
  }
}

//
typedef Prop<T> = MaterialStatePropertyAll<T>;
