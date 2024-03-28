import 'package:flutter/material.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/styles.dart';

class TopicItemWidget extends StatelessWidget with Ui {
  TopicItemWidget({super.key, required this.topic});
  final TopicData topic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey(topic.id),
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        constraints: const BoxConstraints(minHeight: 70),
        width: maxWidth(context) * 0.92,
        decoration: BoxDecoration(
            // color: Ui.black01
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x73000000), offset: Offset(2, 4), blurRadius: 3)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(topic.title, style: medium00),
            // spacer(y: 10),
            Text(topic.category, style: xs01),
            spacer(y: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level', style: xs01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                        children: List.generate(
                            (int.parse(topic.level) / 100).ceil(),
                            (index) => const Icon(Icons.star, size: 10))),
                    Text('${topic.level} level', style: xs01)
                  ],
                ),
              ],
            ),
            Text(() {
              final temp = topic.description;
              return temp.length > 20 ? '${temp.substring(0, 20)}...' : temp;
            }(), style: xs01)
          ],
        ),
      ),
    );
  }
}
