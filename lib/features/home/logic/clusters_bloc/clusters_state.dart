import 'package:equatable/equatable.dart';

abstract class DollarRateState extends Equatable {
  const DollarRateState();
  @override
  List<Object> get props => [];
}

//# initilize State
class DollarRateInitialState extends DollarRateState {}

//#Loading State
class DollarRateLoadingState extends DollarRateState {
  @override
  List<Object> get props => [];
}

//#Successful State
class DollarRateLoadedState extends DollarRateState {
  // final List<DollarRateModel> DollarRateData;
  const DollarRateLoadedState(
      // {required this.DollarRateData}
      );
  @override
  List<Object> get props => [];
}

//#unSuccessful State
class DollarRateLoadingUnsuccessfulState extends DollarRateState {
  final String message;
  const DollarRateLoadingUnsuccessfulState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
