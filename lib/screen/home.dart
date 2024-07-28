// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:qeasily/provider/dashboard_provider.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/qeasily_state.dart';
import 'package:qeasily/redux/redux.dart';
import 'package:qeasily/screen/index.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/test.dart';
import 'package:qeasily/widget/confirm_action.dart';
import 'package:qeasily/widget/widget.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with Ui {
  var navDestination = HoverDestination.home;

  @override
  Widget build(BuildContext context) {
    final dio = ref.watch(generalDioProvider);
    return Scaffold(
        backgroundColor: Ui.black00,
        drawer: _Drawer(),
        body: HomePageSubScreen());
  }
}

class _Drawer extends ConsumerWidget with Ui {
  _Drawer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAuthProvider);
    final dashboard = ref.watch(dashboardProvider);

    return SingleChildScrollView(
      child: Material(
        elevation: 10,
        color: Theme.of(context).colorScheme.background,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(y: 40),
              GestureDetector(
                  // onTap: () => push(APIDoc(), context),
                  child: Text('Qeasily 1.0', style: medium10)),
              spacer(y: 10),
              Divider(color: tiber),
              //
              GestureDetector(
                onTap: () => context.go('/home/plans'),
                child: Container(
                  decoration: BoxDecoration(
                      color: darkShade,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2.5,
                            offset: Offset(2, 3),
                            color: Color(0x5C000000))
                      ],
                      borderRadius: BorderRadius.circular(40)),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.diamond, color: vividOrange),
                      spacer(y: 0),
                      Text(
                        'Buy a Package',
                        style: small10,
                      )
                          .animate(
                              onInit: (controller) => controller.repeat(),
                              autoPlay: true)
                          .shimmer(
                        duration: Duration(seconds: 2),
                        colors: [Colors.white, vividOrange],
                      )
                    ],
                  ),
                ),
              ),
              spacer(y: 30),

              GestureDetector(
                  onTap: () => context.go('/home/dashboard'),
                  child: _drawerTile('Dasboard', Icons.dashboard)),
              spacer(y: 20),
              GestureDetector(
                  onTap: () => context.go('/home/follow'),
                  child:
                      _drawerTile('Follow Creators', Icons.people_alt_rounded)),
              spacer(y: 10),
              StoreConnector<QeasilyState, SessionViewModel>(
                  converter: (store) =>
                      SessionViewModel(store, ref.read(generalDioProvider)),
                  builder: (context, vm) {
                    return vm.history.dcqSessions.isNotEmpty ||
                            vm.history.mcqSessions.isNotEmpty
                        ? GestureDetector(
                            onTap: () => context.go('/home/history'),
                            child: _drawerTile('Resume Quizzes', Icons.save,
                                trailer: circleWrap(
                                    (vm.history.dcqSessions.length +
                                            vm.history.mcqSessions.length)
                                        .toString())),
                          )
                        : SizedBox.shrink();
                  }),
              // spacer(y: 20),
              // _drawerTile('Settings', Icons.settings_suggest),

              spacer(y: 40),
              // if (user.hasValue && user.value!.type == 'Admin') _AdminTiles(),
              switch (dashboard) {
                AsyncData(value: (final msg, final data))
                    when data != null && data.adminPoints > 1 =>
                  _AdminTiles(),
                _ => Center(),
              },
              // Text(user.value!.type),
              spacer(y: 40),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                  onTap: () {
                    //NOTE: handle logout logic here
                    final auth = ref.read(generalDioProvider.notifier);
                    showModal(
                      context: context,
                      builder: (context) => ConfirmAction(
                        action: 'Are you sure you want to Log out',
                        onConfirm: () => Navigator.pop(context, true),
                      ),
                    ).then((value) {
                      if (value == true) {
                        auth.logout(); // log out here
                        context.go('/login');
                      }
                    });
                  },
                  child: Row(children: [
                    Icon(Icons.logout, color: blue10),
                    spacer(x: 10),
                    Text('Log out', style: rubik)
                  ]),
                ),
                spacer(y: 20),
               
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerTile(String labelText, IconData icon, {Widget? trailer}) {
    return Builder(builder: (context) {
      return Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
          ),
          spacer(x: 10),
          Text(
            labelText,
            style: small00,
          ),
          spacer(),
          if (trailer != null)
            Expanded(
                child: Align(alignment: Alignment.centerRight, child: trailer))
        ],
      );
    });
  }
}

class _AdminTiles extends StatelessWidget with Ui {
  _AdminTiles({super.key});

  Widget _drawerTile(String labelText, IconData icon) {
    return Builder(builder: (context) {
      return Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
          ),
          spacer(x: 10),
          Text(labelText, style: rubik),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: raisingBlack,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Admin',
            style: mukta,
          ),
        ),
        Divider(color: Colors.grey),
        spacer(y: 10),
        InkWell(
            overlayColor: MaterialStatePropertyAll(raisingBlack),
            onTap: () {
              context.push('/admin');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              child:
                  _drawerTile('Admin tools', Icons.create_new_folder_rounded),
            )),
        spacer(),
        // Divider(color: Colors.grey),
        InkWell(
            overlayColor: MaterialStatePropertyAll(raisingBlack),
            onTap: () => context.push('/admin/drafts'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: _drawerTile('Drafts', Icons.drafts_rounded),
            )),
      ],
    );
  }
}
