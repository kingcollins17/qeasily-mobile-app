// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:qeasily/provider/auth_provider.dart';
import 'package:qeasily/provider/dio_provider.dart';
import 'package:qeasily/redux/store.dart';
import 'package:qeasily/styles.dart';
import 'package:qeasily/widget/notification.dart';
import 'route_doc.dart';

class TestWidget extends ConsumerStatefulWidget {
  const TestWidget({super.key});

  @override
  ConsumerState<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends ConsumerState<TestWidget>
    with SingleTickerProviderStateMixin, UIStyles {
  bool isLoading = false;
  dynamic data;
  String? response;
  late AnimationController _controller;
  LocalNotification? notification;

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

  Future<void> _notify(String message, {bool? loading}) {
    setState(() {
      notification =
          LocalNotification(animation: _controller, message: message);
    });

    return showNotification(_controller)
        .then((value) => setState(() => notification = null));
  }

  @override
  Widget build(BuildContext context) {
    // final dio = ref.watch(provider)
    final user = ref.watch(userAuthProvider);
    final dio = ref.watch(generalDioProvider);
    return SafeArea(
      child: scrollable(
        Material(
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${dio.options.headers}'),
                    Text('$data'),
                    user.when(
                        data: (userData) => Center(
                              child: Text('$userData'),
                            ),
                        error: (_, __) => center(Text('$_')),
                        loading: () => loader(color: Colors.black)),
                    FilledButton(
                      style: ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(Size(100, 45))),
                      onPressed: () async {
                        var notifier = ref.read(userAuthProvider.notifier);
                        // setState(() {
                        //   isLoading = true;
                        // });
                        // await notifier
                        //     .updateProfile(
                        // username: 'Bleh Kings',
                        // email: 'bleh@gmail.com',
                        // password: 'kingpass',
                        //   firstName: 'Bleh',
                        //   lastName: 'Kings',
                        //   regNo: '2020/216017',
                        //   dept: 'Law',
                        //   level: '100',
                        // )
                        // .then((value) => setState(() {
                        //       data = value;
                        //       isLoading = false;
                        //     }));
                        // ref.refresh(userAuthProvider);
                        Hive.box('settings').put('darkMode', false);
                      },
                      child: isLoading ? loader(sz: 20) : Text('Test'),
                    ),
                    FilledButton(
                      onPressed: () => push(APIDoc(), context),
                      child: Text('Go to API Doc'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class APIDoc extends StatelessWidget {
  const APIDoc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Documentation'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        itemCount: APIUrl.values.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                blurRadius: 3,
                offset: Offset(2, 4),
                color: Color(0x4C000000),
              )
            ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  APIUrl.values[index].name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(baseUrl + APIUrl.values[index].url),
                Text('Request body: ${APIUrl.values[index].body}'),
                Text('Query-params: ${APIUrl.values[index].queryParams}'),
                Text('METHOD: ${APIUrl.values[index].method.name}'),
                const SizedBox(height: 10),
                Text(APIUrl.values[index].extras ?? ""),
                Text('requires authentication: '
                    '${APIUrl.values[index].requiresAuth ? 'Yes' : 'No'}')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
