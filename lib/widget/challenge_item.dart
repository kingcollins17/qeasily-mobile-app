import 'package:flutter/material.dart';
import 'package:qeasily/model/challenge.dart';
import 'package:qeasily/styles.dart';

class ChallengeItemWidget extends StatelessWidget with Ui {
  ChallengeItemWidget(
      {super.key, required this.challenge, required this.onPress});

  final ChallengeData challenge;
  final void Function(ChallengeData value) onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(challenge),
      child: Padding(
        key: ValueKey(challenge.id),
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Container(
          width: maxWidth(context) * 0.9,
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
              color: darkShade,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(2, 4),
                  color: Color(0x47000000),
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(children: [],),
              spacer(y: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(challenge.name, style: small00),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA13131),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.query_builder, size: 10, color: athensGray),
                        spacer(),
                        Text(() {
                          final temp = challenge.dateAdded
                              .add(Duration(days: challenge.duration))
                              .difference(DateTime.now())
                              .inDays;

                          return temp < 1 ? 'Ended' : 'Ends in $temp Days';
                          // return e.duration.toString();
                        }(), style: mukta),
                      ],
                    ),
                  ),
                ],
              ),
              spacer(y: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Icon(Icons.monetization_on, size: 10),
                  Text('Entry Fee: ', style: xs01),
                  Text('${challenge.paid ? challenge.entryFee : "Free"}',
                      style: xs00),
                ],
              ),
              spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text('Type', style: xs01),
                  // spacer(),
                  // Divider(color: Colors.grey, height: 10),
                  Icon(Icons.subscriptions_rounded,
                      size: 20, color: athensGray),
                  spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                        color: raisingBlack,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                        challenge.paid ? 'Paid Challenge' : 'Free Challenge',
                        style: xs01),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
