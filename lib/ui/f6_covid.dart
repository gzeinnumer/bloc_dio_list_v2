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
