import 'package:equatable/equatable.dart';

abstract class DollarRateEvent extends Equatable {
  const DollarRateEvent();
}

class DollarRateFetchEvent extends DollarRateEvent {
  const DollarRateFetchEvent();
  @override
  List<Object?> get props => [];
}
