


import 'package:flutter_bloc/flutter_bloc.dart';

abstract class QuizzState{


}

class InitState extends QuizzState {}

class SuccesState extends QuizzState {
  final int second;
  final int random_number;

  SuccesState({required this.second, required this.random_number});
}
class FailureState extends QuizzState {
    final int second;
  final int random_number;

  FailureState({required this.second, required this.random_number});

}
class TimerState extends QuizzState {
  //   final int second;
  // final int random_number;

  // TimerState({required this.second, required this.random_number});
}






class QuizzCubit extends Cubit<QuizzState> {
  QuizzCubit() : super(TimerState());


  on_click({
    required int current_second,
    required int random_number
  }){

    if(current_second==random_number){
      emit(SuccesState(second: current_second, random_number: random_number));

    }
    else{
      emit(FailureState(second: current_second, random_number: random_number));
    }

  }
  on_start(){
    emit(TimerState());
  }
}