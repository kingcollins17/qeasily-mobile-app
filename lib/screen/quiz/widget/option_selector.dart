// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:qeasily/styles.dart';

class OptionSelector<ValueType> extends StatelessWidget with Ui {
  OptionSelector(
      {super.key,
      required this.values,
      required this.converter,
      required this.onSelect,
      this.selected,
      required this.deselect});
  final List<ValueType> values;
  final ValueType? selected;
  final String Function(ValueType value) converter;
  final void Function(ValueType value) onSelect;
  final void Function() deselect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          values.length,
          (index) => GestureDetector(
                onTap: () => onSelect(values[index]),
                onDoubleTap: selected == values[index] ? deselect : null,
                child: Container(
                  width: maxWidth(context) * 0.85,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  constraints: BoxConstraints(minHeight: 60),
                  decoration: BoxDecoration(
                    color: darkShade,
                    boxShadow: [
                      BoxShadow(blurRadius: 2, color: Color(0x2D000000))
                    ],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: selected == values[index]
                            ? jungleGreen
                            : Colors.transparent,
                        width: 2.5),
                  ),
                  child: Text(converter(values[index]), style: small00),
                ),
              )),
    );
  }
}
