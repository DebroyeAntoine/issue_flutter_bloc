import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

part 'cubit_issue_state.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    var sock =
    await Socket.connect("127.0.0.1", 8124, timeout: Duration(seconds: 5));
    sock.write("loading");
    sleep(Duration(seconds: 2));
    sock.write("good");
    sock.close();
    return Future.value(true);
  });
}

class IssueCubit extends Cubit<IssueState> {
  var serverSocket;

  IssueCubit() : super(IssueState(Colors.grey));

  validate() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Workmanager().cancelAll();
    await Workmanager().initialize(
      callbackDispatcher,
    );
    serverSocket = await ServerSocket.bind('127.0.0.1', 8124, shared: true);
    await serverSocket.listen(handleClient);
    Workmanager().registerPeriodicTask("1", "",);
  }

  void handleClient(Socket client) {
    client.listen((onData) {
      String status = String.fromCharCodes(onData).trim();
      print(status);
      switch (status) {
        case "loading":
          {
            state.status = Colors.blue;
            emit(state);
            break;
          }
        case "good":
          {
            state.status = Colors.green;
            emit(state);
            //in debugger I see the emit is good but doesn't update my background color
            break;
          }
      }
    });
  }
}
