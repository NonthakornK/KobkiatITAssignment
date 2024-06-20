import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel {
  @protected
  late final compositeSubscription = CompositeSubscription();

  void onCleared() {
    compositeSubscription.dispose();
  }
}
