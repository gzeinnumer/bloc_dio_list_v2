abstract class CovidListEvent {}

class CovidListChanged extends CovidListEvent {
  final List<Object> list;

  CovidListChanged({required this.list});
}

class CovidListSubmitted extends CovidListEvent {}