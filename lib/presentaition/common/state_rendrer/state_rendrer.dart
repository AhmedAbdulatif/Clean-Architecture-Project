import 'package:clean_arc_app/app/constants.dart';
import 'package:clean_arc_app/presentaition/resources/assets_manager.dart';
import 'package:clean_arc_app/presentaition/resources/color_manager.dart';
import 'package:clean_arc_app/presentaition/resources/font_manager.dart';
import 'package:clean_arc_app/presentaition/resources/strings_manager.dart';
import 'package:clean_arc_app/presentaition/resources/styles_manager.dart';
import 'package:clean_arc_app/presentaition/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum StateRendrerType {
  // popup
  popupLoadingState,
  popupSuccessState,
  popupErrorState,
  // full screen
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,
  // general
  contentState
}

class StateRendrer extends StatelessWidget {
  final StateRendrerType stateRendrerType;
  final String title;
  final String message;
  final Function retryActionFunction;
  const StateRendrer(
      {Key? key,
      required this.stateRendrerType,
      this.message = AppStrings.loading,
      this.title = Constants.empty,
      required this.retryActionFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendrerType) {
      case StateRendrerType.popupLoadingState:
        return _getPopupDialog(context, [
          _getAnimatedImage(JsonAssets.loading),
        ]);
      case StateRendrerType.popupSuccessState:
        return _getPopupDialog(context, [
          _getAnimatedImage(JsonAssets.success),
          _getMessage(title),
          _getMessage(message),
          _getButton(AppStrings.ok.tr(), context),
        ]);
      case StateRendrerType.popupErrorState:
        return _getPopupDialog(context, [
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getButton(AppStrings.ok.tr(), context),
        ]);

      case StateRendrerType.fullScreenLoadingState:
        return _getItemColumn([
          _getAnimatedImage(JsonAssets.loading),
          _getMessage(message),
        ]);
      case StateRendrerType.fullScreenErrorState:
        return _getItemColumn([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getButton(AppStrings.retryAgain.tr(), context),
        ]);
      case StateRendrerType.fullScreenEmptyState:
        return _getItemColumn([
          _getAnimatedImage(JsonAssets.empty),
          _getMessage(message),
        ]);
      case StateRendrerType.contentState:
        return Container();
      default:
        return Container();
    }
  }

  Widget _getPopupDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppSize.s14,
        ),
      ),
      elevation: AppSize.s1_5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
            ),
          ],
        ),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getItemColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName) {
    return Center(
      child: SizedBox(
        width: AppSize.s100,
        height: AppSize.s100,
        child: Lottie.asset(animationName),
      ),
    );
  }

  Widget _getMessage(String messageText) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(
          messageText,
          style: getRegularStyle(
            color: ColorManager.black,
            fontSize: FontSize.s18,
          ),
        ),
      ),
    );
  }

  Widget _getButton(String buttonTitle, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (stateRendrerType ==
                      StateRendrerType.fullScreenErrorState) {
                    retryActionFunction.call();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(buttonTitle))),
      ),
    );
  }
}
