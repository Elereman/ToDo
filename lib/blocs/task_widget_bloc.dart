import 'dart:async';

import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart' as states;

class TaskWidgetPageBloc {
  final StreamController<Event> _eventStreamController;
  final StreamController<states.State> _stateStreamController;

  TaskWidgetPageBloc()
      : _eventStreamController = StreamController<Event>(),
        _stateStreamController = StreamController<states.State>() {
    _eventStreamController.stream.listen((event) => _handleEvent(event));
  }

  void _handleEvent(Event event) {
    switch (event.type) {
      case TaskPressedEvent:
        print('TaskPressed');
        break;
    }
  }

  Stream<states.State> get stateStream => _stateStreamController.stream;
  Sink<Event> get eventSink => _eventStreamController.sink;
}