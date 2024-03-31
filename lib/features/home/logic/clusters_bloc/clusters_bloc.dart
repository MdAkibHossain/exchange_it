import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/home/logic/clusters_bloc/clusters_event.dart';
import 'package:flutter_application_1/features/home/logic/clusters_bloc/clusters_state.dart';
import '../../../../core/data/dataproviders/dio_client.dart';
import '../../../../core/utils/debug_utils.dart';

class DollarRateBloc extends Bloc<DollarRateEvent, DollarRateState> {
  final ApiProvider? apiProvider;
  DollarRateBloc(this.apiProvider) : super(DollarRateInitialState()) {
    on<DollarRateFetchEvent>(
      (event, emit) async {
        emit(DollarRateLoadingState());
        logView("DollarRate");
        // String DollarRateId = event.DollarRateId;
        await apiProvider
            ?.getCallWithOutToken(
                url:
                    'https://exchange-it-c1ba5-default-rtdb.firebaseio.com/dollarRate/dollarBuyingRate')
            .then(
          (Either<DioError, Response> response) {
            response.fold(
              (l) {
                logError(
                    "Failed TO FETCHED Area Api  Repos! [${l.response?.statusCode}] -> [[${l.type.toString()}]]");
                // final type = NetworkExceptions.getDioException(l);
                // final message = NetworkExceptions.getErrorMessage(type);
                emit(DollarRateLoadingUnsuccessfulState(
                  message: "message",
                ));
              },
              (r) {
                //  Map<String, dynamic> dataMap = r.data as Map<String, dynamic>;
                logView("DollarRate in model");
                logView(r.toString());
                //List<DollarRateModel> DollarRateData = [];

                // dataMap["data"].forEach((dynamic data) {
                //   DollarRateModel datas = DollarRateModel.fromJson(data);
                //   DollarRateData.add(datas);
                // }
                // );

                // emit(DollarRateLoadedState(DollarRateData: DollarRateData));
              },
            );
          },
        );
      },
    );
  }
}
