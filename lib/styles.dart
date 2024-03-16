import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

///
mixin Ui {
  final primary = const Color(0xFF916BFF);
  final blue1 = const Color(0xFF5C99FF);
  final blue10 = const Color(0xFF1B56BD);
  // final shimmer = const Color(0xFFD6D6D6);

  static Color grey = const Color(0xFF8A8A8A),
      lightGrey = Color(0xFFC0C0C0),
      darkGrey = const Color(0xFF2C2C2C),
      black00 = Colors.black,
      black01 = const Color(0xFF272727);

  final TextStyle xs00 = GoogleFonts.workSans(
        fontSize: 12,
      ),
      xs01 = GoogleFonts.workSans(fontSize: 12, color: Color(0x88FFFFFF)),
      small00 = GoogleFonts.workSans(fontSize: 16),
      small10 = GoogleFonts.workSans(fontSize: 16, fontWeight: FontWeight.w500),
      mukta = GoogleFonts.mukta(fontSize: 16, color: lightGrey),
      rubik = GoogleFonts.rubik(fontSize: 16),
      // small03 = GoogleFonts.firaSans(fontSize: 16),
      big04 = GoogleFonts.notoSans(fontSize: 16),
      medium00 = GoogleFonts.workSans(fontSize: 18, color: Colors.white),
      medium10 =
          GoogleFonts.workSans(fontSize: 18, fontWeight: FontWeight.bold),
      big14 = GoogleFonts.notoSans(fontSize: 24, fontWeight: FontWeight.bold),
      big12 = GoogleFonts.rubik(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      clock = GoogleFonts.notoSans(fontSize: 24);

  Widget loader({Color color = Colors.white, double sz = 50}) =>
      Center(child: SpinKitThreeInOut(size: sz, color: color));

  double maxWidth(BuildContext context) => MediaQuery.of(context).size.width;

  double maxHeight(BuildContext context) => MediaQuery.of(context).size.height;

  Widget shimmer({double? w, double? h, double? br}) => Builder(
      builder: (context) => Container(
          width: w ?? maxWidth(context) * 0.4,
          height: h ?? 10,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(br ?? 10),
          )));

  Widget vDivider({double? w, double? h, Color? color}) => Container(
        width: w ?? 1.5,
        height: h ?? 30,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: color ?? Color(0xB7636363),
          borderRadius: BorderRadius.circular(15),
        ),
      );

  Widget spacer({
    double x = 5,
    double y = 5,
  }) =>
      SizedBox(height: y, width: x);

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
