import 'f2_covid_status.dart';

class CovidListState {
  final List<Object> list;
  final CovidListStatus formStatus;

  CovidListState({
    this.list = const [],
    this.formStatus = const CovidListInit(),
  });

  CovidListState copyWith({
    List<Object>? list,
    CovidListStatus? formStatus,
  }) {
    return CovidListState(
      list: list ?? this.list,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
