import 'dart:async';

import 'package:ToDo/presentation/blocs/events.dart';
import 'package:ToDo/presentation/blocs/states.dart';


class TaskWidgetPageBloc {
  final StreamController<BlocEvent> _eventStreamController;
  final StreamController<BlocState<dynamic>> _stateStreamController;

  TaskWidgetPageBloc()
      : _eventStreamController = StreamController<BlocEvent>(),
        _stateStreamController = StreamController<BlocState<dynamic>>() {
    _eventStreamController.stream.listen((BlocEvent event) => _handleEvent(event));
  }

  void _handleEvent(BlocEvent event) {
    switch (event.type) {
      case TaskPressedEvent:
        print('TaskPressed');
        break;
    }
  }

  Stream<BlocState<dynamic>> get stateStream => _stateStreamController.stream;
  Sink<BlocEvent> get eventSink => _eventStreamController.sink;
}