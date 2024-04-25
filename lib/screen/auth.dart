// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/route_doc.dart';
import 'package:qeasily/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qeasily/widget/custom_drop_down.dart';
import 'package:qeasily/widget/local_notification.dart';
import 'package:qeasily/widget/store_notification.dart';

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
                                            color: tiber,
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
                                  // Text('Dont have an account?  Register',
                                  //   style: mukta,
                                  // ),
                                  Text('OR', style: xs00),
                                  spacer(),
                                  TextButton(
                                      onPressed: () {
                                        context.go('/sign-up');
                                      },
                                      child: Text(
                                        'Create an Account',
                                        style: rubik.copyWith(
                                            fontSize: 16, color: Colors.white),
                                      ))
                                  // Divider(color: Colors.grey)
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

  String? username, email, password, level, department, confirmPassword;
  LocalNotification? notification;

  String? rawNotification;

  _SignUpStep currentStep = _SignUpStep.details;

  // bool showPassword = false, showConfirm = false;

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

  Future<(bool, String)> _createAccount() async {
    final dio = ref.read(generalDioProvider);
    try {
      final response = await dio.post(
        APIUrl.register.url,
        data: {
          'user_name': username,
          'email': email,
          'password': password,
          'department': department,
          'level': level
        },
      );
      return (response.statusCode == 200, response.data['detail'].toString());
    } catch (e) {
      return (false, e.toString());
    }
  }

  String? validator(String? value) =>
      value == null || value.isEmpty ? 'This field is required' : null;

  @override
  Widget build(BuildContext context) {
    return stackWithNotifier([
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              spacer(y: 35),
              progressionBar(),
              spacer(y: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    currentStep.index > 0
                        ? GestureDetector(
                            onTap: () => setState(() => currentStep =
                                _SignUpStep.values[currentStep.index - 1]),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: raisingBlack,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.arrow_back_ios,
                                  color: Colors.grey, size: 15),
                            ),
                          )
                        : spacer(),
                    Text(
                        'Steps ${currentStep.index + 1} of ${_SignUpStep.values.length}',
                        style: medium00),
                  ],
                ),
              ),
              spacer(y: 20),
              switch (currentStep) {
                _SignUpStep.details => enterDetails(),
                _SignUpStep.identity => emailAndUsername(),
                _SignUpStep.auth => enterPassword(),
              }
            ],
          ),
        ),
      ),
      // if (rawNotification != null)
      Positioned(
          bottom: 15,
          child: SleekNotification(
              notification: rawNotification,
              closer: () => setState(() {
                    rawNotification = null;
                  }))),
    ], notification);
  }

  InputDecoration _idecor(String label) => InputDecoration(
      isDense: true,
      border: OutlineInputBorder(borderSide: BorderSide()),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: jungleGreen)),
      labelText: label,
      labelStyle: small00.copyWith(color: Colors.white));

  Widget enterPassword() {
    return Form(
        key: formKey,
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text('You are almost there!',
                    style: small00.copyWith(
                        fontSize: 18, fontWeight: FontWeight.bold))),
            spacer(),
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Create a password for your account',
                    style: small00.copyWith(fontSize: 14))),
            spacer(y: 15),
            TextFormField(
              validator: (value) => value == null || value.length < 8
                  ? 'Password must be at least 8 Characters'
                  : null,
              obscureText: !showPassword,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(borderSide: BorderSide()),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: jungleGreen)),
                labelText: 'Password',
                labelStyle: small00.copyWith(color: Colors.white),
                suffixIcon: GestureDetector(
                  onTap: () => setState(() {
                    showPassword = !showPassword;
                  }),
                  child: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      size: 22,
                      color: athensGray),
                ),
              ),
            ),
            spacer(y: 15),
            TextFormField(
              obscureText: !showConfirm,
              validator: (value) =>
                  value == password ? null : 'Confirm does not match password',
              onChanged: (value) => confirmPassword = value,
              decoration: InputDecoration(
                  isDense: true,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() {
                      showConfirm = !showConfirm;
                    }),
                    child: Icon(
                        showConfirm ? Icons.visibility : Icons.visibility_off,
                        size: 22,
                        color: athensGray),
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: jungleGreen)),
                  labelText: 'Confirm Password',
                  labelStyle: small00.copyWith(color: Colors.white)),
            ),
            spacer(y: 30),
            FilledButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(jungleGreen),
                  fixedSize: MaterialStatePropertyAll(
                      Size(maxWidth(context) * 0.92, 45)),
                ),
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    rawNotification =
                        'Please wait while we create an account for you';
                    _notify('Creating your account ...', loading: !isLoading);
                    if (department != null &&
                        level != null &&
                        username != null &&
                        email != null &&
                        password != null) {
                      _notify('Please wait ...');
                      _createAccount().then((value) async {
                        await _notify(value.$2, loading: false);
                        if (value.$1) {
                          // ignore: use_build_context_synchronously
                          context.go('/login');
                        }
                      });
                    } else {
                      rawNotification = null;
                      _notify('Some details were not provided', loading: false);
                    }
                  }
                },
                child: isLoading
                    ? SpinKitDualRing(color: Colors.white, size: 25)
                    : Text('Create Account',
                        style: rubik.copyWith(color: Colors.white)))
          ],
        ));
  }

  Widget emailAndUsername() {
    return Form(
        key: formKey,
        child: Column(
          children: [
            spacer(y: 10),
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Your email and username', style: small00)),
            spacer(y: 20),
            TextFormField(
              validator: validator,
              onChanged: (value) => username = value,
              // decoration: InputDecoration(
              //   border: OutlineInputBorder(),
              //   isDense: true,
              //   labelText: 'Username',
              //   labelStyle: small00,
              // ),
              decoration: _idecor('Username'),
            ),
            spacer(y: 20),
            TextFormField(
              validator: validator,
              onChanged: (value) => email = value,
              // decoration: InputDecoration(
              //   border: OutlineInputBorder(),
              //   isDense: true,
              //   labelText: 'Email',
              //   labelStyle: small00,
              // ),
              decoration: _idecor('Email'),
            ),
            spacer(y: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                spacer(),
                // spacer(x: 20),
                FilledButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false)
                        setState(() {
                          currentStep =
                              _SignUpStep.values[currentStep.index + 1];
                        });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(jungleGreen)),
                    child: Text('Next Step',
                        style: rubik.copyWith(color: Colors.white)))
              ],
            )
          ],
        ));
  }

  Widget enterDetails() {
    return Form(
        key: formKey,
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Enter your details', style: rubik)),
            spacer(y: 15),
            TextFormField(
              validator: validator,
              onChanged: (value) => department = value,
              // decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     isDense: true,
              //     labelText: 'Department',
              //     labelStyle: small00),
              decoration: _idecor('Department'),
            ),
            spacer(y: 20),
            CustomDropdownField(
                items: ['100', '200', '300', '400', '500', '600'],
                onChanged: (value) => level = value,
                hint: level ?? 'Current level',
                converter: (value) => value),
            spacer(y: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                onPressed: () {
                  if (level != null &&
                      (formKey.currentState?.validate() ?? false)) {
                    setState(() {
                      currentStep = _SignUpStep.values[currentStep.index + 1];
                    });
                  } else {
                    _notify('You must fill this page before you proceed');
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(jungleGreen)),
                child: Text('Next Step',
                    style: small00.copyWith(color: Colors.white)),
              ),
            )
          ],
        ));
  }

  Widget progressionBar() {
    return SizedBox(
      width: maxWidth(context),
      child: Row(children: [
        spacer(x: 2),
        ...List.generate(
            _SignUpStep.values.length,
            (index) => Expanded(
                  child: Container(
                    height: 6,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            currentStep.index > _SignUpStep.values[index].index
                                ? deepSaffron
                                : Colors.grey),
                  ),
                )),
        spacer(x: 2),
      ]),
    );
  }
}

enum _SignUpStep { details, identity, auth }
