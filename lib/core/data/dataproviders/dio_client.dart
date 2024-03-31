import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constants.dart';

class ApiProvider {
  late Dio dio;
  String baseurl = "https://amarshohorbeta.com/api";

  ApiProvider() {
    BaseOptions options = BaseOptions(
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        // "Authorization": "Bearer $token"
      },
      baseUrl: baseurl,
      receiveTimeout: 60000,
      connectTimeout: 60000,
    );
    // BaseOptions options = BaseOptions(
    //   headers: {
    //     'Content-type': 'application/json',
    //     'Accept': 'application/json',
    //     // "Authorization": "Bearer $token"
    //   },
    //   baseUrl: baseurl,
    //   receiveTimeout: Duration(milliseconds: 1),
    //   connectTimeout: Duration(milliseconds: 1),
    // );

    dio = Dio(options);
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
    ));
  }

  // Get Api without Token
  Future<Either<DioError, Response>> getCallWithOutToken({
    dynamic params,
    required String url,
  }) async {
    String data = params ?? "";
    return await Task(() => dio.get(
          url + data,
        )).attempt().run().then((either) {
      return either.fold((l) {
        return Left(l as DioError);
      }, (r) {
        return Right(r);
      });
    });
  }

  // ## Get Api With Token
  Future<Either<DioError, Response>> getCallWithToken(
      {required String url, dynamic params}) async {
    var token =
        (await SharedPreferences.getInstance()).getString(AUTH_TOKEN_KEY);
    String data = params ?? "";
    return await Task(() => dio.get(
          url + data,
          options: Options(headers: {"authorization": "Bearer ${token ?? ""}"}),
        )).attempt().run().then((either) {
      return either.fold((l) {
        return Left(l as DioError);
      }, (r) {
        return Right(r);
      });
    });
  }

//# Post Api with Token
  Future<Either<DioError, Response>> postCallWithToken({
    data,
    url,
  }) async {
    var token =
        (await SharedPreferences.getInstance()).getString(AUTH_TOKEN_KEY);
    // //## for Testing
    // var urls = Uri.parse("$url");
    // var response = await http
    //     .post(urls, body: data, headers: {"authorization": "Bearer $token"});
    // print('------------Response-------------');
    // print(response.body);
    return await Task(() => dio.post(url,
            data: data,
            options: Options(headers: {"authorization": "Bearer $token"})))
        .attempt()
        .run()
        .then((either) {
      return either.fold((l) {
        return Left(l as DioError);
      }, (r) {
        return Right(r);
      });
    });
  }

  //# Patch Api with Token
  Future<Either<DioError, Response>> patchCallWithToken({
    data,
    url,
  }) async {
    var token =
        (await SharedPreferences.getInstance()).getString(AUTH_TOKEN_KEY);
    return await Task(() => dio.patch(url,
        data: data,
        options: Options(headers: {
          "authorization": "Bearer $token",
        }))).attempt().run().then((either) {
      return either.fold((l) {
        final e = l as DioError;
        return Left(e);
      }, (r) {
        return Right(r);
      });
    });
  }

  //# Put Api with Token
  Future<Either<DioError, Response>> putCallWithToken({
    data,
    url,
  }) async {
    var token =
        (await SharedPreferences.getInstance()).getString(AUTH_TOKEN_KEY);
    return await Task(() => dio.put(url,
        data: data,
        options: Options(headers: {
          "authorization": "Bearer $token",
        }))).attempt().run().then((either) {
      return either.fold((l) {
        final e = l as DioError;
        return Left(e);
      }, (r) {
        return Right(r);
      });
    });
  }

  //# Post Api with Token
  Future<Either<DioError, Response>> patchCallWithTokenMultiPath({
    data,
    url,
  }) async {
    var token =
        (await SharedPreferences.getInstance()).getString(AUTH_TOKEN_KEY);
    return await Task(() => dio.patch(url,
        data: data,
        options: Options(headers: {
          "authorization": "Bearer $token",
          'Content-Type': 'multipart/formData'
        }))).attempt().run().then((either) {
      return either.fold((l) {
        return Left(l as DioError);
      }, (r) {
        return Right(r);
      });
    });
  }

// ## Post Apicall without token
  Future<Either<DioError, Response>> postCallWithOutToken({
    data,
    url,
  }) async {
    return await Task(() => dio.post(
          url,
          data: data,
        )).attempt().run().then((either) {
      return either.fold((l) {
        return Left(l as DioError);
      }, (r) {
        return Right(r);
      });
    });
  }

//# Post Api with Token
  Future<Either<DioError, Response>> deletedCallWithToken({
    data,
    url,
  }) async {
    var token =
        (await SharedPreferences.getInstance()).getString(AUTH_TOKEN_KEY);
    return await Task(() => dio.delete(url,
            data: data,
            options: Options(headers: {"authorization": "Bearer $token"})))
        .attempt()
        .run()
        .then((either) {
      return either.fold((l) {
        return Left(l as DioError);
      }, (r) {
        return Right(r);
      });
    });
  }
}

//////;;;0-------////////
