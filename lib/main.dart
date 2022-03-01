import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue_flutter_bloc/cubit_issue_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => IssueCubit(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssueCubit, IssueState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: state.status,
              body: Center(
                child: TextButton(
                    onPressed: () {
                      BlocProvider.of<IssueCubit>(context).validate();
                    },
                    child: const Text("Start")),
              )
          );
        });
  }
}

