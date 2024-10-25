part of 'toggleicon_bloc.dart';

@immutable
sealed class ToggleiconState {}

final class ToggleiconInitial extends ToggleiconState {
  final bool isOn;
  ToggleiconInitial(this.isOn);
}
