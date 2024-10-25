import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'toggleicon_event.dart';
part 'toggleicon_state.dart';

class ToggleiconBloc extends Bloc<ToggleiconEvent, ToggleiconState> {
  ToggleiconBloc() : super(ToggleiconInitial(false)) {
    on<ToglleSuffixIconEvent>((event, emit) {
      emit(ToggleiconInitial(!(state as ToggleiconInitial).isOn));
    });
  }
}
