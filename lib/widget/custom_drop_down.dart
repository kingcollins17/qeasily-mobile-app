// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qeasily/styles.dart';

class CustomDropdownField<Item> extends StatelessWidget with Ui {
  CustomDropdownField({
    super.key,
    this.hint,
    required this.items,
    required this.onChanged,
    required this.converter,
  });

  final String? hint;
  final List<Item> items;
  final void Function(Item) onChanged;
  final String Function(Item) converter;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 48,
        decoration: BoxDecoration(
          color: raisingBlack,
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButtonFormField<int>(
          hint: Text(hint ?? '', style: xs01),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: const InputDecoration(border: InputBorder.none),
          isDense: true,
          items: List.generate(
            items.length,
            (index) => DropdownMenuItem(
                value: index,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    converter(items[index]),
                    style: mukta,
                  ),
                )),
          ),
          onChanged: (value) {
            if (value != null) onChanged(items[value]);
          },
        ));
  }
}
