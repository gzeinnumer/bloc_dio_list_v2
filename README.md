# bloc_dio_list_v2

- f1_covid_repository.dart
```dart
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
```
- f2_covid_status.dart
```dart
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
```
- f3_covid_state.dart
```dart
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
```
- f4_covid_event.dart
```dart
abstract class CovidListEvent {}

class CovidListChanged extends CovidListEvent {
  final List<Object> list;

  CovidListChanged({required this.list});
}

class CovidListSubmitted extends CovidListEvent {}
```
- f5_covid_bloc.dart
```dart
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
```
- f6_covid.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/covid/f5_covid_bloc.dart';
import '../bloc/covid/f4_covid_event.dart';
import '../bloc/covid/f3_covid_state.dart';
import '../bloc/covid/f2_covid_status.dart';
import '../repo/f1_covid_repository.dart';

class CovidView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  CovidView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CovidListBloc(
              authRepo: context.read<CovidRepository>(),
            ),
          )
        ],
        child: _CovidForm(),
      ),
    );
  }

  Widget _CovidForm() {
    return BlocListener<CovidListBloc, CovidListState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is CovidListOnFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _usernameField(),
                _covidButton(),
              ],
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<CovidListBloc, CovidListState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
        validator: (value) =>
        state.list.isEmpty ? null : 'Username is too short',
        // onChanged: (value) => context.read<CovidListBloc>().add(
        //   CovidListChanged(list: value),
        // ),
      );
    });
  }

  Widget _covidButton() {
    return BlocBuilder<CovidListBloc, CovidListState>(builder: (context, state) {
      return state.formStatus is CovidListOnShowLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<CovidListBloc>().add(CovidListSubmitted());
          }
        },
        child: const Text('Covid'),
      );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
```
- main.dart
```dart
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
```

---

```
Copyright 2022 M. Fadli Zein
```