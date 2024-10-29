
import 'package:flutter_riverpod/flutter_riverpod.dart';

final obscureControllerProvider = StateNotifierProvider<ObscureController, bool>((ref) {
  return ObscureController(true);
});

final confirmPasswordVisibilityProvider = StateNotifierProvider<ObscureController, bool>((ref) {
  return ObscureController(true); // true for initially hidden
});

class ObscureController extends StateNotifier<bool>{
  ObscureController(super.state);


  void changeVisibility(){
    state = !state;
  }

  // void changeVisibilityToConfirmField(){
  //   state = !state;
  // }

}