import 'dart:async';

import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart';

class TaskWidgetPageBloc {
  final StreamController<BlocEvent> _eventStreamController;
  final StreamController<BlocState> _stateStreamController;

  TaskWidgetPageBloc()
      : _eventStreamController = StreamController<BlocEvent>(),
        _stateStreamController = StreamController<BlocState>() {
    _eventStreamController.stream.listen((event) => _handleEvent(event));
  }

  void _handleEvent(BlocEvent event) {
    switch (event.type) {
      case TaskPressedEvent:
        print('TaskPressed');
        break;
    }
  }

  Stream<BlocState> get stateStream => _stateStreamController.stream;
  Sink<BlocEvent> get eventSink => _eventStreamController.sink;
}