import '../../../core/error/app_exception.dart';

class DayAlreadyClosedException implements AppException {
  const DayAlreadyClosedException();

  @override
  String get message => 'Hari ini sudah ditutup.';

  @override
  String toString() => message;
}
