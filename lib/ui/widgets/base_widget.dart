import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget child) builder;
  // this function is used when we want to implement some logic in the onInit()
  // function of the widget using the provided viewModel.
  final Function(T) onModelReady;

  final T model;
  final Widget child;

  BaseWidget({Key key, this.model, this.builder, this.child, this.onModelReady})
      : super(key: key);

  @override
  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  // V.I.I.I::  We want to store the instance of the model in the state
  // that .way it stays constant through rebuilds
  T model;

  @override
  void initState() {
    //  init model internally at the state to preserve it through rebuilds.
    model = widget.model;
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
