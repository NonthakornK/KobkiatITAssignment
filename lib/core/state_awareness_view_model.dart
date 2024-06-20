import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'base_view_model.dart';

mixin StateAwarenessViewModel<ViewModel extends BaseViewModel,
    T extends StatefulWidget> on State<T> {
  ViewModel? _viewModel;

  @override
  void dispose() {
    _viewModel?.onCleared();
    super.dispose();
  }

  @protected
  ViewModel viewModel([dynamic param1, dynamic param2]) {
    if (_viewModel != null) {
      throw StateError(
        "Creating multiple instance of viewmodels is not supported, as the instance of the original one can cause memory leak",
      );
    }
    _viewModel = GetIt.I<ViewModel>(param1: param1, param2: param2);
    return _viewModel!;
  }

  void clearViewModel() {
    _viewModel?.onCleared();
    _viewModel = null;
  }
}
