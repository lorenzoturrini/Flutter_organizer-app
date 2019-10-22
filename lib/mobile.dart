import 'dart:io' show Platform;
import 'package:fb_auth/fb_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venturiautospurghi/utils/global_contants.dart' as global;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:venturiautospurghi/view/splash_screen.dart';

import 'bloc/authentication_bloc/authentication_bloc.dart';
import 'bloc/backdrop_bloc/backdrop_bloc.dart';
import 'utils/theme.dart';
import 'view/backdrop.dart';
import 'view/log_in_view.dart';

final tabellaUtenti = 'Utenti';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Table Calendar Demo',
          theme: customLightTheme,
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is Unauthenticated) {
                return LogIn();
              }else if (state is Authenticated) {
                return BlocProvider(
                    builder: (context) {
                      firebaseCloudMessaging_Listeners(state.user);
                      return BackdropBloc(state.user, state.isSupervisor)..dispatch(InitAppEvent());//dispatch(NavigateEvent(global.Constants.homeRoute,null));
                      },
                    child: Backdrop()
                );
              }
              return SplashScreen();
            },
          ),
    );
  }

  void firebaseCloudMessaging_Listeners(AuthUser user){
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) async {
      QuerySnapshot documents = (await Firestore.instance.collection(tabellaUtenti).getDocuments());
      var e = user.email;
      for (DocumentSnapshot document in documents.documents) {
        if(document != null && document.data['Email'] == e) {
          if(document.data['Token'] != token){
            Firestore.instance.collection(tabellaUtenti).document(document.documentID).updateData(<String,dynamic>{"Token":token});
          }
          break;
        }
      }
      print("token: "+token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }
}