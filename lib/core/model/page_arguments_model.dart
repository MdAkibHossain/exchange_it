class PageRouteArguments {
  final String? fromPage;
  final String? toPage;
  final List<dynamic>? datas;
  final String? title;
  final dynamic data;
  final String? id;
  final int? businessTypeId;
  final bool? commonBool;
  PageRouteArguments(
      {this.commonBool,
      this.data,
      this.title,
      this.fromPage,
      this.toPage,
      this.datas,
      this.id,
      this.businessTypeId});
}

class PageRouteIdArgument<T> {
  final T id;

  PageRouteIdArgument({required this.id});
}
