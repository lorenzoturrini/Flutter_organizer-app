//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:venturiautospurghi/plugin/dispatcher/platform_loader.dart';
import 'bloc/authentication_bloc/authentication_bloc.dart';
import 'bloc/simple_bloc_delegate.dart';

//run dependend by platform
//the actual main is in mobile.dart and/or web.dart
void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  initializeDateFormatting("it_IT").then((_) => runApp(
    BlocProvider(
        builder: (context) => AuthenticationBloc()
          ..dispatch(AppStarted()),
        child: PlatformUtils.myApp),
  )
  );
}

