import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart' as states;
import 'package:rxdart/rxdart.dart';

class TaskDialogBloc {
  final BehaviorSubject<Event> _eventStreamController;
  final BehaviorSubject<states.State> _stateStreamController;

  TaskDialogBloc()
      : _eventStreamController = BehaviorSubject<Event>(),
        _stateStreamController = BehaviorSubject<states.State>(){
    _eventStreamController.stream.listen((event) => _handleEvent(event));
  }

  void _handleEvent(Event event) {
    switch (event.type) {
      case ColorChangedEvent:
        print('ColorChanged');
        ColorChangedEvent colorChanged = event as ColorChangedEvent;
        _stateStreamController.add(ColorChangedState(colorChanged.colorHex));
        break;
    }
  }

  Stream<states.State> get stateStream => _stateStreamController.stream;
  Sink<Event> get eventSink => _eventStreamController.sink;
}

class ColorChangedEvent extends Event {
  final colorHex;

  ColorChangedEvent(this.colorHex);
}

class ColorChangedState<T> extends states.State {
  final T data;

  ColorChangedState(this.data);

  @override
  get stateData => data;
}