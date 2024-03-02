// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qeasily/styles.dart';

class HoverMenu extends StatefulWidget {
  const HoverMenu({super.key, this.onChanged});
  final void Function(HoverDestination dest)? onChanged;
  @override
  State<HoverMenu> createState() => _HoverMenuState();
}

class _HoverMenuState extends State<HoverMenu>
    with SingleTickerProviderStateMixin, UIStyles {
  late AnimationController _controller;

  var _currentDestination = HoverDestination.home;
  final iconMap = <HoverDestination, (IconData, IconData)>{
    HoverDestination.home: (Icons.home_outlined, Icons.home_filled),
    HoverDestination.explore: (Icons.explore_outlined, Icons.explore_rounded),
    HoverDestination.feed: (Icons.feed, Icons.feed_rounded),
    HoverDestination.me: (Icons.person_3_outlined, Icons.person_3_rounded)
  };

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
    const height = 56.0;
    return Center(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          
          border: Border.all(color: Color(0xB3BEBEBE)),
          boxShadow: [
            BoxShadow(
              blurRadius: 2.5, offset: Offset(2, 3), color: Color(0x2B000000))
          ],
        color: Theme.of(context).colorScheme.background,
        // color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...HoverDestination.values.map(
            (value) => _destination(
              value,
              _currentDestination,
              iconMap[value]!.$1,
              selectedIcon: iconMap[value]!.$2,
              onTap: (arg) {
                setState(() => _currentDestination = arg);
                if (widget.onChanged != null) {
                  Future.delayed(Duration(milliseconds: 600), () {
                    widget.onChanged!(arg);
                  });
                }
              },
            ),
          )
        ],
      ),
    ));
  }

  Widget _destination(
      HoverDestination value, HoverDestination groupValue, IconData icon,
      {IconData? selectedIcon, void Function(HoverDestination arg)? onTap}) {
    return Expanded(
      flex: value == groupValue ? 2 : 1,
      child: GestureDetector(
        onTap: () => onTap != null ? onTap(value) : null,
        child: LayoutBuilder(builder: (context, constraints) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            height: 56,
            width: value == groupValue
                ? constraints.maxWidth
                : constraints.maxWidth - 5,
            decoration: BoxDecoration(
              gradient: value == groupValue
                  ? LinearGradient(colors: [purple1, blue1])
                  : null,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                  selectedIcon != null && value == groupValue
                      ? selectedIcon
                      : icon,
                  color: value == groupValue ? Colors.white : blue10),
              if (value == groupValue) ...[
                spacer(y: 0),
                txt(() {
                  final h = value.name[0];
                  return h.toUpperCase() + value.name.substring(1);
                }(), cx: Colors.white),
              ]
            ]),
          );
        }),
      ),
    );
  }
}

enum HoverDestination { home, explore, feed, me }
