// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class _HomeScreenState extends ConsumerState<HomeScreen> with UIStyles {
  var navDestination = HoverDestination.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: _Drawer(),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.98,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background),
                height: MediaQuery.of(context).size.height * 0.95,
                child: PageTransitionSwitcher(
                  duration: Duration(milliseconds: 650),
                  transitionBuilder: (child, primary, secondaryAnimation) =>
                      SharedAxisTransition(
                    animation: primary,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  ),
                  child: navDestination.index == 0
                      ? IndexSubScreen()
                      : null,
                ),
              ),
              Positioned(
                bottom: 20,
                width: MediaQuery.of(context).size.width,
                child: HoverMenu(
                    onChanged: (dest) => setState(() => navDestination = dest)),
              )
            ],
          ),
        ));
  }
}

class _Drawer extends ConsumerWidget with UIStyles {
  _Drawer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAuthProvider);

    return Material(
      elevation: 10,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(y: 40),
            txt('Qeasily 1.0',
                sz: 18,
                weight: FontWeight.bold,
                cx: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.7)),
            Divider(color: purple1),
            // spacer(),
            GestureDetector(
              onTap: () => push(APIDoc(), context),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2.5,
                          offset: Offset(2, 3),
                          color: Color(0x2D000000))
                    ],
                    borderRadius: BorderRadius.circular(4)),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.diamond, color: Colors.deepOrange),
                    spacer(y: 0),
                    txt('Subscription and Pricing',
                        cx: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.8))
                  ],
                ),
              ),
            ),
            spacer(y: 30),
            _drawerTile('Paid Challenges', Icons.price_check_outlined),
            spacer(y: 20),
            _drawerTile('Leaderboards', Icons.leaderboard_rounded),
            spacer(y: 20),
            _drawerTile('Contact us', Icons.feedback),
            spacer(y: 20),
            _drawerTile('Settings', Icons.settings_suggest_sharp),
            spacer(y: 40),
            _AdminTiles(),
            Expanded(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(children: [
                Icon(Icons.logout, color: blue10),
                spacer(x: 10),
                txt('Log out', cx: blue10)
              ]),
              spacer(y: 20),
              Row(children: [
                Icon(Icons.delete, color: Colors.redAccent),
                spacer(x: 10),
                txt('Delete Account', cx: Colors.redAccent)
              ]),
              spacer(y: 10),
              txt('Terms of use'),
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
          txt(labelText,
              cx: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
        ],
      );
    });
  }
}

class _AdminTiles extends StatelessWidget with UIStyles {
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
          txt(labelText,
              cx: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        txt(
          'Admin',
          sz: 12,
          cx: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
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
