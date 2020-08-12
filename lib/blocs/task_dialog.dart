import 'package:ToDo/blocs/events.dart';
import 'package:ToDo/blocs/states.dart';
import 'package:rxdart/rxdart.dart';

class TaskDialogBloc {
  final BehaviorSubject<BlocEvent> _eventStreamController;
  final BehaviorSubject<BlocState<dynamic>> _stateStreamController;

  TaskDialogBloc()
      : _eventStreamController = BehaviorSubject<BlocEvent>(),
        _stateStreamController = BehaviorSubject<BlocState<dynamic>>(){
    _eventStreamController.stream.listen((BlocEvent event) => _handleEvent(event));
  }

  void _handleEvent(BlocEvent event) {
    switch (event.type) {
      case ColorChangedEvent:
        print('ColorChanged');
        final ColorChangedEvent colorChanged = event as ColorChangedEvent;
        _stateStreamController.add(ColorChangedState<int>(colorChanged.colorHex));
        break;
    }
  }

  Stream<BlocState<dynamic>> get stateStream => _stateStreamController.stream;
  Sink<BlocEvent> get eventSink => _eventStreamController.sink;
}

class ColorChangedEvent extends BlocEvent {
  final int colorHex;

  ColorChangedEvent(this.colorHex);
}

class ColorChangedState<T> extends BlocState<T> {
  final T data;

  ColorChangedState(this.data);

  @override
  T get stateData => data;
}