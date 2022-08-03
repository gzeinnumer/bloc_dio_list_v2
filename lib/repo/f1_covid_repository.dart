class CovidRepository {
  Future<void> getCovidList() async {
    // print('attempting login');
    await Future.delayed(const Duration(seconds: 3));
    // print('logged in');
    throw Exception('failed log in');
  }

  Future<bool> getCovidListB() async {
    // print('attempting login');
    await Future.delayed(const Duration(seconds: 3));
    // print('logged in');
    // throw Exception('failed log in');
    return true;
  }
}