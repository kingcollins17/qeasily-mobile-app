import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

///
mixin UIStyles {
  final purple1 = const Color(0xFF916BFF);
  final blue1 = const Color(0xFF5C99FF);
  final blue10 = const Color(0xFF1B56BD);

  final shimmer = const Color(0xFFD6D6D6);

  ///SizedBox()
  Widget sb(Widget child, [double? w, double? h]) => Builder(
        builder: (context) => Center(
          child: SizedBox(
            height: h,
            width: w ?? MediaQuery.of(context).size.width,
            child: child,
          ),
        ),
      );

  Widget button(Widget child, {VoidCallback? onTap}) =>
      Builder(builder: (context) {
        return InkWell(
            overlayColor: MaterialStatePropertyAll(purple1.withAlpha(100)),
            borderRadius: BorderRadius.circular(50),
            onTap: onTap,
            // overlayColor: MaterialStatePropertyAll(blue1.withAlpha(150)),
            child: Ink(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 48,
                decoration: BoxDecoration(
                    // gradient: LinearGradient(colors: []),
                    borderRadius: BorderRadius.circular(50),
                    color: blue1,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 2,
                        color: Color.fromRGBO(240, 177, 177, 0.176),
                        offset: Offset(2, 4),
                      )
                    ]),
                child: Center(
                  child: child,
                )));
      });

  Widget authSymbol() => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          // gradient: LinearGradient(
          //     colors: [purple1.withAlpha(200), Color(0xFFFFFFFF)]),
          boxShadow: [BoxShadow(blurRadius: 4, color: blue1.withAlpha(70))],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.lock_outline_rounded, size: 30, color: purple1),
      );

  Widget outerBox(Widget child, [double? width]) =>
      Center(child: SizedBox(width: width, child: child));

  Widget center(Widget child) => Center(child: child);

  Widget loader({Color color = Colors.white, double sz = 50}) =>
      Center(child: SpinKitThreeInOut(size: sz, color: color));

  Widget pad(Widget child, {double x = 15, double y = 0}) => Padding(
      padding: EdgeInsets.symmetric(horizontal: x, vertical: y), child: child);

  Widget scrollable(Widget child, [Axis direction = Axis.vertical]) {
    return SingleChildScrollView(scrollDirection: direction, child: child);
  }

  Widget spacer({
    double x = 5,
    double y = 5,
  }) =>
      SizedBox(height: y, width: x);

  // Widget wspacer([double space = 5]) => SizedBox(width: space);
  Widget txt(String text,
          {double sz = 14, Color? cx, TextAlign? align, FontWeight? weight}) =>
      Builder(builder: (context) {
        return Text(
          text,
          textAlign: align,
          style: GoogleFonts.poppins(
            fontSize: sz,
            fontWeight: weight,
            textStyle: TextStyle(
                color: cx ?? Theme.of(context).textTheme.bodyMedium?.color,
                decoration: TextDecoration.none),
          ),
        );
      });
  Widget stackWithNotifier(List<Widget> children, [Widget? notification]) =>
      Builder(builder: (context) {
        return Stack(children: [
          ...children,
          if (notification != null)
            Positioned(
              top: 30,
              width: MediaQuery.of(context).size.width,
              child: Center(child: notification),
            )
        ]);
      });

  //actions
  Future<T?> push<T>(Widget child, BuildContext context) {
    return Navigator.of(context)
        .push<T>(MaterialPageRoute<T>(builder: (context) => child));
  }
}
