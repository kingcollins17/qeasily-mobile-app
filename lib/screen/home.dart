// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/test.dart';
import 'package:qeasily/widget/widget.dart';
import 'nav/nav.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with Ui {
  var navDestination = HoverDestination.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Ui.black00,
        drawer: _Drawer(),
        body: Stack(
          children: [
            IndexSubScreen(),
          ],
        ));
  }
}

class _Drawer extends ConsumerWidget with Ui {
  _Drawer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAuthProvider);

    return Material(
      elevation: 10,
      color: Ui.black00,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(y: 40),
            GestureDetector(
                onTap: () => context.go('/test'),
                child: Text('Qeasily 1.0', style: medium10)),
            spacer(y: 10),
            Divider(color: purple1),
            //
            GestureDetector(
              onTap: () => push(APIDoc(), context),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
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
                    Icon(Icons.diamond, color: Colors.deepOrange),
                    spacer(y: 0),
                    Text(
                      'Subscription and Pricing',
                      style: small10,
                    ).animate(
                        effects: [ShimmerEffect(), ShakeEffect()],
                        autoPlay: true)
                  ],
                ),
              ),
            ),
            spacer(y: 30),
            _drawerTile('Dasboard', Icons.dashboard),
            spacer(y: 20),
            _drawerTile('Follow Creators', Icons.people_alt_rounded),
            spacer(y: 20),
            _drawerTile('Notifications', Icons.notifications_active),
            spacer(y: 20),
            _drawerTile('Settings', Icons.settings_suggest),
            
            spacer(y: 40),
            _AdminTiles(),
            Expanded(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(children: [
                Icon(Icons.logout, color: blue10),
                spacer(x: 10),
                Text('Log out', style: small02)
              ]),
              spacer(y: 20),
              Row(children: [
                Icon(Icons.delete, color: Colors.redAccent),
                spacer(x: 10),
                Text('Delete Account', style: small02)
              ]),
              spacer(y: 10),
              Text('Terms of use', style: small01),
              spacer(y: 25)
            ]))
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(String labelText, IconData icon) {
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
          Text(labelText, style: small02),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Admin',
          style: small01,
        ),
        Divider(color: Colors.grey),
        spacer(y: 15),
        _drawerTile('Creations', Icons.create_new_folder_rounded),
        spacer(y: 15),
        // Divider(color: Colors.grey),
        _drawerTile('Drafts', Icons.drafts_rounded),
      ],
    );
  }
}
