///
class QeasilyAction {
  final Payload? payload;

  QeasilyAction({this.payload});
}

class Payload {
  void Function(Object?)? onDone, onError;

  Payload({this.onDone, this.onError});
}

class NotifyPayload extends Payload {
  final String message;

  NotifyPayload(this.message);
}

class UpdatePayload<T> extends Payload {
  final T data;

  UpdatePayload(this.data);
}
