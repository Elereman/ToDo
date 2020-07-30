import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart' as states;
import 'package:rxdart/rxdart.dart';

class TaskDialogBloc {
  final BehaviorSubject<Event> _eventStreamController;
  final BehaviorSubject<states.State<dynamic>> _stateStreamController;

  TaskDialogBloc()
      : _eventStreamController = BehaviorSubject<Event>(),
        _stateStreamController = BehaviorSubject<states.State<dynamic>>(){
    _eventStreamController.stream.listen((Event event) => _handleEvent(event));
  }

  void _handleEvent(Event event) {
    switch (event.type) {
      case ColorChangedEvent:
        print('ColorChanged');
        final ColorChangedEvent colorChanged = event as ColorChangedEvent;
        _stateStreamController.add(ColorChangedState<int>(colorChanged.colorHex));
        break;
    }
  }

  Stream<states.State<dynamic>> get stateStream => _stateStreamController.stream;
  Sink<Event> get eventSink => _eventStreamController.sink;
}

class ColorChangedEvent extends Event {
  final int colorHex;

  ColorChangedEvent(this.colorHex);
}

class ColorChangedState<T> extends states.State<T> {
  final T data;

  ColorChangedState(this.data);

  @override
  T get stateData => data;
}