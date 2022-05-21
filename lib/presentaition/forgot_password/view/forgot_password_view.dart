import 'package:clean_arc_app/presentaition/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../app/di.dart';
import '../../common/state_rendrer/state_rendrer_imp.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final ForgotPasswordViewModel _forgotPasswordViewModel =
      getIt<ForgotPasswordViewModel>();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _bind() {
    _forgotPasswordViewModel.start();
    _emailController.addListener(() {
      _forgotPasswordViewModel.setEmail(_emailController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _forgotPasswordViewModel.outputState,
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return snapShot.data!.getScreenWidget(context, _getContentWidget(),
                () {
              _forgotPasswordViewModel.resetPassword(context);
            });
          } else {
            return _getContentWidget();
          }
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p100),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(
                  child: Image(image: AssetImage(ImageAssets.splashLogo))),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _forgotPasswordViewModel.outputIsEmailValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: AppStrings.username.tr(),
                          labelText: AppStrings.username.tr(),
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.usernameError.tr(),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _forgotPasswordViewModel.outputIsResetButtonActive,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                            onPressed: (snapshot.data ?? false)
                                ? () {
                                    _forgotPasswordViewModel
                                        .resetPassword(context);
                                  }
                                : null,
                            child: Text(AppStrings.resetPassword.tr())),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
