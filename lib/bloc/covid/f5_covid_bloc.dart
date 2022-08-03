import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/f1_covid_repository.dart';
import 'f4_covid_event.dart';
import 'f3_covid_state.dart';
import 'f2_covid_status.dart';

class CovidListBloc extends Bloc<CovidListEvent, CovidListState> {
  final CovidRepository authRepo;

  CovidListBloc({required this.authRepo}) : super(CovidListState());

  @override
  Stream<CovidListState> mapEventToState(CovidListEvent event) async* {
    // Username updated
    if (event is CovidListChanged) {
      yield state.copyWith(list: event.list);

      // Password updated
    } else if (event is CovidListSubmitted) {
      yield state.copyWith(formStatus: CovidListOnShowLoading());

      try {
        // await akan menggung dulu
        // Detik 1 - 2
        await authRepo.getCovidList(); // Detik 3
        //Detik 4

        bool res = await authRepo.getCovidListB();
        //res if true
        //action
        //res else false
        //action

        yield state.copyWith(formStatus: CovidListOnSuccess());
      } on Exception catch (e) {
        yield state.copyWith(formStatus: CovidListOnFailed(e));
      }
    }
  }
}