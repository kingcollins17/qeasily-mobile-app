// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/util/create_question_util.dart';

import 'questions/questions.dart';

class AdminManageScreen extends ConsumerStatefulWidget {
  const AdminManageScreen({super.key});
  @override
  ConsumerState<AdminManageScreen> createState() => _AdminManageScreenState();
}

class _AdminManageScreenState extends ConsumerState<AdminManageScreen> with Ui {
  // var tool = _Toolset.create;

  @override
  Widget build(BuildContext context) {
    return stackWithNotifier([
      Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                spacer(x: 10),
                Text('Admin Tools', style: small00),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon(Icons.visibility, size: 18, color: athensGray),
                // spacer(),
                spacer(y: 15),
                Text('Delete Tool', style: small00),
                spacer(y: 10),
                InkWell(
                  onTap: () => context.push('/admin/view-questions'),
                    overlayColor: MaterialStatePropertyAll(raisingBlack),
                    borderRadius: BorderRadius.circular(6),
                    child: _deleteTile(
                      label: 'Delete Questions',
                      subscript: 'This action deletes costs 2 admin credits',
                      icon: Icons.delete_outline,
                    )),
                spacer(y: 15),
                InkWell(
                  onTap: () => context.push('/admin/view-topics'),
                    overlayColor: MaterialStatePropertyAll(raisingBlack),
                    borderRadius: BorderRadius.circular(6),
                    child: _deleteTile(
                      label: 'Delete Topic',
                      subscript: 'This action costs 2 admin credits',
                      icon: Icons.delete_outline,
                    )),
                spacer(y: 15),
                InkWell(
                  onTap: () => context.push('/admin/view-quizzes'),
                    overlayColor: MaterialStatePropertyAll(raisingBlack),
                    borderRadius: BorderRadius.circular(6),
                    child: _deleteTile(
                      label: 'Delete Quiz',
                      subscript: 'This action costs 1 admin credits',
                      icon: Icons.delete_outline_rounded,
                    )),

                spacer(y: 50),
                Text('Create Tool', style: small00),
                spacer(y: 15),
                InkWell(
                    onTap: () => context.push('/admin/create-quiz'),
                    overlayColor: MaterialStatePropertyAll(raisingBlack),
                    borderRadius: BorderRadius.circular(6),
                    child: _createTile(
                        label: 'Create Quiz',
                        subscript: 'Costs 2 admin credits',
                        icon: Icons.create)),
                spacer(y: 15),
                InkWell(
                    onTap: () => context.push('/admin/create-question'),
                    overlayColor: MaterialStatePropertyAll(raisingBlack),
                    borderRadius: BorderRadius.circular(6),
                    child: _createTile(
                      label: 'Create Questions ',
                      subscript: '1 questions costs 0.5 admin credits',
                      icon: Icons.question_mark_rounded,
                    )),
                spacer(y: 15),
                // _createTile('Create Quiz +'),
                InkWell(
                    onTap: () => context.push('/admin/create-topic'),
                    overlayColor: MaterialStatePropertyAll(raisingBlack),
                    borderRadius: BorderRadius.circular(6),
                    child: _createTile(
                        label: 'Create Topic',
                        subscript: 'Costs 2 admin credits',
                        icon: Icons.topic_rounded)),
                spacer(y: 15),
                // Text('Delete', style: mukta),
                spacer(y: 10),
                // Wrap(
                //   runSpacing: 4,
                //   spacing: 4,
                //   children: [
                //     _createTile('Delete Question'),
                //     _createTile('Delete Quiz'),
                //   ],
                // ),
              ],
            ),
          )),
    ]);
  }

  Widget _deleteTile(
      {required String label,
      required String subscript,
      required IconData icon}) {
    return Ink(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: raisingBlack,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: athensGray),
          ),
          spacer(x: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: small00.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              spacer(),
              Text(subscript, style: xs01),
            ],
          )
        ],
      ),
    );
  }

  Widget _createTile(
      {required String label,
      required String subscript,
      required IconData icon}) {
    return Ink(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: raisingBlack,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: jungleGreen),
          ),
          spacer(x: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: small00.copyWith(fontWeight: FontWeight.bold)),
              spacer(),
              Text(subscript, style: xs01)
            ],
          ),
        ],
      ),
    );
  }
}

enum _Toolset { create, delete }
