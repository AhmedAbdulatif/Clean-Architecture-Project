import 'package:clean_arc_app/app/di.dart';
import 'package:clean_arc_app/domain/model/models.dart';
import 'package:clean_arc_app/presentaition/common/state_rendrer/state_rendrer_imp.dart';
import 'package:clean_arc_app/presentaition/resources/color_manager.dart';
import 'package:clean_arc_app/presentaition/resources/strings_manager.dart';
import 'package:clean_arc_app/presentaition/resources/values_manager.dart';
import 'package:clean_arc_app/presentaition/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({Key? key}) : super(key: key);

  @override
  State<StoreDetailsView> createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  final _viewModel = getIt<StoreDetailsViewModel>();

  _bind() {
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return snapShot.data!.getScreenWidget(context, _getContentWidget(),
                () {
              _viewModel.getStoreDetails();
            });
          }
          return Container();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder<StoreDetails>(
      stream: _viewModel.outPutStoreDetails,
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppStrings.storeDetails.tr()),
            ),
            body: Container(
              constraints: const BoxConstraints.expand(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: AppSize.s160,
                      child: Card(
                        elevation: AppSize.s1_5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSize.s12),
                            side: BorderSide(
                                color: ColorManager.primary,
                                width: AppSize.s1)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSize.s12),
                          child: Image.network(snapShot.data!.image,
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    _getSection(AppStrings.details.tr()),
                    _getText(snapShot.data!.details),
                    _getSection(AppStrings.services.tr()),
                    _getText(snapShot.data!.services),
                    _getSection(AppStrings.about.tr()),
                    _getText(snapShot.data!.about),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppPadding.p12,
          left: AppPadding.p12,
          right: AppPadding.p12,
          bottom: AppPadding.p2),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  Widget _getText(String text) {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppPadding.p12,
          left: AppPadding.p12,
          right: AppPadding.p12,
          bottom: AppPadding.p2),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
