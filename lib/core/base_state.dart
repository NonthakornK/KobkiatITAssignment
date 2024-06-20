import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @protected
  final compositeSubscription = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    compositeSubscription.dispose();
    super.dispose();
  }
}
