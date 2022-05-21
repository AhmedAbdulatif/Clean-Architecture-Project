import 'package:clean_arc_app/app/constants.dart';
import 'package:clean_arc_app/presentaition/common/state_rendrer/state_rendrer.dart';
import 'package:clean_arc_app/presentaition/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendrerType getStateRendrerType();
  String getMessage();
}

// loading state [full screen / popup]
class LoadingState extends FlowState {
  StateRendrerType stateRendrerType;
  String message;
  LoadingState(
      {required this.stateRendrerType, this.message = AppStrings.loading});
  @override
  String getMessage() {
    return message.tr();
  }

  @override
  StateRendrerType getStateRendrerType() {
    return stateRendrerType;
  }
}

class SuccessState extends FlowState {
  StateRendrerType stateRendrerType;
  String titleMessage;
  String bodyMessage;
  SuccessState(
      {required this.stateRendrerType,
      this.titleMessage = "success",
      required this.bodyMessage});

  @override
  String getMessage() {
    return bodyMessage;
  }

  @override
  StateRendrerType getStateRendrerType() {
    return stateRendrerType;
  }
}

// loading state [full screen / popup]
class ErrorState extends FlowState {
  StateRendrerType stateRendrerType;
  String message;
  ErrorState({required this.stateRendrerType, required this.message});
  @override
  String getMessage() {
    return message;
  }

  @override
  StateRendrerType getStateRendrerType() {
    return stateRendrerType;
  }
}

// content state [actual app data ex carousel images etc..]
class ContentState extends FlowState {
  ContentState();
  @override
  String getMessage() {
    return Constants.empty;
  }

  @override
  StateRendrerType getStateRendrerType() {
    return StateRendrerType.contentState;
  }
}

// empty state [no data]
class EmptyState extends FlowState {
  String message;

  EmptyState({required this.message});
  @override
  String getMessage() {
    return message;
  }

  @override
  StateRendrerType getStateRendrerType() {
    return StateRendrerType.fullScreenEmptyState;
  }
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreen,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendrerType() == StateRendrerType.popupLoadingState) {
            // show dialog
            showPopup(context, getMessage(), getStateRendrerType());
            // keep the content screen
            return contentScreen;
          } else {
            return StateRendrer(
                message: getMessage(),
                stateRendrerType: getStateRendrerType(),
                retryActionFunction: retryActionFunction);
          }
        }

      case SuccessState:
        {
          dismissDialog(context);
          // show dialog
          showPopupSuccess(context, getMessage(), getStateRendrerType());
          // keep the content screen
          return contentScreen;
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendrerType() == StateRendrerType.popupErrorState) {
            // show dialog
            showPopup(context, getMessage(), getStateRendrerType());
            // keep the content screen
            return contentScreen;
          } else {
            return StateRendrer(
                message: getMessage(),
                stateRendrerType: getStateRendrerType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreen;
        }
      case EmptyState:
        {
          return StateRendrer(
              stateRendrerType: getStateRendrerType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction);
        }
      default:
        {
          dismissDialog(context);
          return contentScreen;
        }
    }
  }

  showPopup(
      BuildContext context, String message, StateRendrerType stateRendrerType) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (context) {
            return StateRendrer(
                stateRendrerType: stateRendrerType,
                message: message,
                retryActionFunction: () {});
          });
    });
  }

  showPopupSuccess(
      BuildContext context, String message, StateRendrerType stateRendrerType) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (context) {
            return StateRendrer(
                stateRendrerType: stateRendrerType,
                title: "Success",
                message: message,
                retryActionFunction: () {});
          });
    });
  }

  bool _isAnotherDialogAlreadyShown(BuildContext context) =>
      ModalRoute.of(context)!.isCurrent != true;

  dismissDialog(BuildContext context) {
    if (_isAnotherDialogAlreadyShown(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }
}
