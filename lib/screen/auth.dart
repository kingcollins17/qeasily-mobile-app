// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qeasily/provider/dio.dart';
import 'package:qeasily/redux/action/auth_actions.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/redux/state/auth.dart';
import 'package:qeasily/widget/widget.dart';
import 'package:redux/redux.dart';

class Authentication extends ConsumerStatefulWidget {
  const Authentication({super.key});
  @override
  ConsumerState<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends ConsumerState<Authentication>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  late AnimationController _controller;

  String? email, password;

  String? _emailValidator(String? value) => value == null || value.isEmpty
      ? 'Email is required'
      : value.split('@').length < 2
          ? 'Email is not valid'
          : value.split('.').length < 2
              ? 'Email is not valid'
              : null;

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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<QeasilyState, _ViewModel>(
        converter: (store) => _ViewModel(store),
        builder: (context, vm) {
          return Stack(
            children: [
              Scaffold(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  style: GoogleFonts.quicksand(),
                                  onChanged: (value) => email = value,
                                  validator: _emailValidator,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    labelText: 'Email',
                                    prefixIcon:
                                        Icon(Icons.mail_outline_rounded),
                                    labelStyle: GoogleFonts.quicksand(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  obscureText: obscurePassword,
                                  onChanged: (value) => password = value,
                                  validator: (value) => value == null ||
                                          value.isEmpty
                                      ? 'Password is required to authenticate your login'
                                      : null,
                                  style: GoogleFonts.quicksand(),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    labelText: 'Password',
                                    prefixIcon:
                                        Icon(Icons.lock_outline_rounded),
                                    suffixIcon: GestureDetector(
                                        onTap: () => setState(() =>
                                            obscurePassword = !obscurePassword),
                                        child: Icon(obscurePassword
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded)),
                                    labelStyle: GoogleFonts.quicksand(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                FilledButton(
                                    onPressed: () {
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        showNotification(_controller);
                                        vm.dispatch(AuthAction(
                                          type: AuthActionType.login,
                                          payload: LoginPayload(
                                              client: ref.read(dioProvider),
                                              email: email!,
                                              password: password!,
                                              onDone: (_) => showNotification(
                                                  _controller)),
                                        ));
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStatePropertyAll(
                                            Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                45))),
                                    child: Text(
                                      'Sign In',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary))
                                  ],
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              if (vm.auth.message != null)
                Positioned(
                    top: 25,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: LocalNotification(
                      animation: _controller,
                      message: vm.auth.message,
                      color: const Color.fromARGB(255, 39, 39, 39),
                      backgroundColor: Theme.of(context).colorScheme.background,
                    )))
            ],
          );
        });
  }
}

class _ViewModel {
  final Store<QeasilyState> _store;
  final AuthState auth;
  _ViewModel(Store<QeasilyState> store)
      : _store = store,
        auth = store.state.auth;
  void dispatch(action) => _store.dispatch(action);
}
