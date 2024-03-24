import 'package:flutter/material.dart';
import 'package:qeasily/model/model.dart';
import 'package:qeasily/styles.dart';

class QuizItemWidget extends StatelessWidget with Ui {
  QuizItemWidget({super.key, required this.quiz});
  final QuizData quiz;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey(quiz.id),
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // height: 100,
        constraints: const BoxConstraints(minHeight: 110),
        decoration: BoxDecoration(
            color: darkShade,
            borderRadius: BorderRadius.circular(8),
            // color: Ui.black01,
            boxShadow: const [
              BoxShadow(
                  blurRadius: 4, color: Color(0xCE000000), offset: Offset(2, 4))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 50),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: raisingBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ...List.generate(
                        switch (quiz.difficulty) {
                          'Hard' => 3,
                          'Medium' => 2,
                          'Easy' => 1,
                          _ => 0,
                        },
                        (index) =>
                            Icon(Icons.star, color: jungleGreen, size: 12),
                      ),
                      spacer(),
                      Text(quiz.difficulty, style: xs01),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.query_builder_outlined,
                        size: 10,
                        color: Colors.grey,
                      ),
                      spacer(x: 6),
                      Text(
                        '${Duration(seconds: quiz.duration).inMinutes} Minutes',
                        style: xs01,
                      )
                    ],
                  ),
                ],
              ),
            ),
            spacer(y: 10),
            Row(
              children: [
                Text(quiz.title, style: small00),
              ],
            ),
            spacer(y: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Questions: ', style: xs01),
                Text('${quiz.questionsAsInt.length} Questions', style: xs00),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Type: ', style: xs01),
                Text(
                  () {
                    final temp = quiz.type;
                    return temp == 'mcq' ? 'Multiple Choice' : 'True or False';
                  }(),
                  style: xs00,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
