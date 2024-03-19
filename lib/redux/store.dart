import 'package:qeasily/redux/state.dart';
import 'package:redux/redux.dart';
import 'mware/mware.dart';

final store = Store(appReducer, initialState: QeasilyState(), middleware: [
  topicMware,
  quizMware,
  chgMware,
]);

