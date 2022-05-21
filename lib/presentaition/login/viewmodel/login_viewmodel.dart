import 'dart:async';

import 'package:clean_arc_app/domain/usecase/login_usecase.dart';
import 'package:clean_arc_app/presentaition/base/base_viewmodel.dart';
import 'package:clean_arc_app/presentaition/common/state_rendrer/state_rendrer.dart';
import 'package:clean_arc_app/presentaition/common/state_rendrer/state_rendrer_imp.dart';

import '../../common/freezed_data_classes.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  final LoginUseCase _loginUseCase;
  LoginViewModel(this._loginUseCase);

  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();

  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();

  final StreamController _loginButtonStreamController =
      StreamController<void>.broadcast();

  final StreamController isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  var loginObject = LoginObject("", "");

  // inputs

  @override
  void start() {
    // view model should tell view please show content state
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _passwordStreamController.close();
    _loginButtonStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  setPassword(String password) {
    _passwordStreamController.add(password);
    loginObject = loginObject.copyWith(password: password);
    _loginButtonStreamController.add(null);
  }

  @override
  setUserName(String userName) {
    _userNameStreamController.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    _loginButtonStreamController.add(null);
  }

  @override
  login() async {
    inputState.add(LoadingState(
        stateRendrerType: StateRendrerType.popupLoadingState,
        message: "login...."));
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold((failure) {
      inputState.add(ErrorState(
          stateRendrerType: StateRendrerType.popupErrorState,
          message: failure.message));
    }, (data) {
      inputState.add(ContentState());
      isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputAreAllInputsValid => _loginButtonStreamController.sink;

  // outputs

  @override
  Stream<bool> get outIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outIsUsernameValid => _userNameStreamController.stream
      .map((userName) => _isUsernameValid(userName));

  @override
  Stream<bool> get outAreAllInputsValid =>
      _loginButtonStreamController.stream.map((_) => araAllInputsValid());

  bool araAllInputsValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUsernameValid(loginObject.userName);
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUsernameValid(String userName) {
    return userName.isNotEmpty;
  }
}

abstract class LoginViewModelInputs {
  setUserName(String userName);
  setPassword(String password);
  login();

  Sink get inputUserName;
  Sink get inputPassword;
  Sink get inputAreAllInputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUsernameValid;
  Stream<bool> get outIsPasswordValid;
  Stream<bool> get outAreAllInputsValid;
}
