import 'dart:async';

import 'package:clean_arc_app/app/functions.dart';
import 'package:clean_arc_app/domain/usecase/forgot_password_usecase.dart';
import 'package:clean_arc_app/presentaition/base/base_viewmodel.dart';
import 'package:clean_arc_app/presentaition/common/state_rendrer/state_rendrer.dart';
import 'package:clean_arc_app/presentaition/common/state_rendrer/state_rendrer_imp.dart';
import 'package:clean_arc_app/presentaition/resources/font_manager.dart';
import 'package:clean_arc_app/presentaition/resources/styles_manager.dart';
import 'package:clean_arc_app/presentaition/resources/values_manager.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  ForgotPasswordViewModel(this._forgotPasswordUseCase);
  StreamController emailStreamController = StreamController<String>.broadcast();
  StreamController resetButtonStreamController =
      StreamController<void>.broadcast();
  String email = "";
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    super.dispose();
    emailStreamController.close();
    resetButtonStreamController.close();
  }

  @override
  resetPassword(BuildContext context) async {
    inputState.add(
        LoadingState(stateRendrerType: StateRendrerType.popupLoadingState));
    (await _forgotPasswordUseCase.execute(email)).fold((failure) {
      print(failure.message);
      inputState.add(ErrorState(
          stateRendrerType: StateRendrerType.popupErrorState,
          message: failure.message));
    }, (data) {
      inputState.add(SuccessState(
          stateRendrerType: StateRendrerType.popupSuccessState,
          bodyMessage: data));
      //inputState.add(ContentState());
    });
  }

  @override
  setEmail(String email) {
    emailStreamController.add(email);
    this.email = email;
    resetButtonStreamController.add(null);
  }

  @override
  Sink get inputResetButton => resetButtonStreamController.sink;

  @override
  Sink get inputEmail => emailStreamController.sink;

  @override
  Stream<bool> get outputIsEmailValid =>
      emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outputIsResetButtonActive =>
      resetButtonStreamController.stream.map((_) => isEmailValid(email));

  bool isEmailValid(String email) {
    if (email.isEmpty) {
      return false;
    } else {
      return checkEmail(email);
    }
  }
}

abstract class ForgotPasswordViewModelInputs {
  setEmail(String email);
  resetPassword(BuildContext context);
  Sink get inputEmail;
  Sink get inputResetButton;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputIsEmailValid;
  Stream<bool> get outputIsResetButtonActive;
}
