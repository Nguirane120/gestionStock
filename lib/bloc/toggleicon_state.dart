part of 'toggleicon_bloc.dart';

@immutable
abstract class ToggleiconState {}

 class ToggleiconInitial extends ToggleiconState {
  final bool isOn;
  ToggleiconInitial(this.isOn);
}
