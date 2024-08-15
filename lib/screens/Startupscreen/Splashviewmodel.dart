import 'package:stacked/stacked.dart';

class SplashViewModel extends BaseViewModel {
  bool _isSplashDone = false;
  bool get isSplashDone => _isSplashDone;

  void checkSplash() async {
    await Future.delayed(Duration(seconds: 3));
    _isSplashDone = true;
    notifyListeners();
  }
}
