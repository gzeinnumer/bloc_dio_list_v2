abstract class CovidListStatus {
  const CovidListStatus();
}

class CovidListInit extends CovidListStatus {
  const CovidListInit();
}

class CovidListOnShowLoading extends CovidListStatus {}

class CovidListOnHideLoading extends CovidListStatus {}

class CovidListOnSuccess extends CovidListStatus {}

class CovidListOnFailed extends CovidListStatus {
  final Exception exception;

  CovidListOnFailed(this.exception);
}