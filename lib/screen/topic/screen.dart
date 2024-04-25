// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qeasily/provider/categories.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/custom_drop_down.dart';
import 'package:qeasily/widget/local_notification.dart';

import 'util/util.dart';

class CreateTopicScreen extends ConsumerStatefulWidget {
  const CreateTopicScreen({super.key});
  @override
  ConsumerState<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends ConsumerState<CreateTopicScreen>
    with Ui, SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late AnimationController _controller;
  LocalNotification? notification;

  //
  String? title, description, level;
  CategoryData? category;

  dynamic data;

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

  Future<void> _notify(String message, {int delay = 4, bool? loading}) async {
    setState(() {
      isLoading = loading ?? isLoading;
      notification =
          LocalNotification(animation: _controller, message: message);
    });

    return showNotification(_controller, delay);
  }

  @override
  Widget build(BuildContext context) {
    return stackWithNotifier([
      Scaffold(
        appBar: AppBar(title: Text('Create Topic', style: small00)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // Text(data.toString()),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    spacer(y: 25),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Topic Name', style: mukta)),
                    spacer(y: 10),
                    TextFormField(
                      style: small00,
                      validator: (value) => value == null || value.isEmpty
                          ? 'This Field is required'
                          : null,
                      onChanged: (value) => title = value,
                      decoration: InputDecoration(
                        // labelText: 'Name',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    spacer(y: 20),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Description', style: mukta)),
                    spacer(y: 10),
                    TextFormField(
                        minLines: 2,
                        maxLines: 5,
                        validator: (value) => value == null || value.isEmpty
                            ? 'This Field is required'
                            : null,
                        onChanged: (value) => description = value,
                        style: small00,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: 'Write a short description of this topic',
                          hintStyle: mukta,
                        )),
                    spacer(y: 25),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Select Category', style: mukta)),
                    spacer(y: 12),
                    switch (ref.read(categoriesProvider)) {
                      AsyncData(:final value) => CustomDropdownField(
                          hint: 'select category for this topic',
                          items: value,
                          onChanged: (arg) {
                            category = arg;
                          },
                          converter: (arg) => arg.name),
                      _ => SizedBox()
                    },
                    spacer(y: 20),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Level', style: mukta)),
                    spacer(y: 15),
                    CustomDropdownField(
                      hint: 'What level',
                      items: ['100', '200', '300', '400', '500', '600'],
                      onChanged: (value) => level = value,
                      converter: (arg) => arg,
                    )
                  ],
                ),
              ),
              spacer(y: 150),
            ],
          ),
        ),
      ),
      Positioned(
          bottom: 20,
          width: maxWidth(context),
          child: Center(
            child: FilledButton(
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                    Size(maxWidth(context) * 0.8, 42),
                  ),
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  foregroundColor: MaterialStatePropertyAll(Colors.black),
                ),
                onPressed: () async {
                  if ((_formKey.currentState?.validate() ?? false) &&
                      category != null &&
                      level != null) {
                    _notify('Creating topic, please wait ...', loading: true);
                    final (msg, status) = await createTopic(
                      ref.read(generalDioProvider),
                      title: title!,
                      description: description!,
                      categoryId: category!.id,
                      //TODO: Remove this field requirement from backend
                      // userId: 1,
                    );
                    _notify(msg, loading: false);
                  } else {
                    _notify('Please fill in all the fields before you proceed',
                        loading: false);
                  }
                },
                child: isLoading
                    ? SpinKitThreeBounce(color: Colors.black, size: 20)
                    : Text('Create Topic', style: rubik)),
          ))
    ], notification);
  }
}
