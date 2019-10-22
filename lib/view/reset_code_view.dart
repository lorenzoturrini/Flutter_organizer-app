import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_web/material.dart';
import 'package:venturiautospurghi/utils/global_contants.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:venturiautospurghi/bloc/backdrop_bloc/backdrop_bloc.dart';
import 'package:venturiautospurghi/utils/global_contants.dart' as global;
import 'package:venturiautospurghi/utils/global_methods.dart';

//https://developers.google.com/identity/sms-retriever/verify

class ResetCode extends StatefulWidget {
  String code;

  @override
  State<StatefulWidget> createState(){
    return new _ResetCodeState();
  }

  ResetCode(this.code){
    createState();
  }
}

class _ResetCodeState extends State<ResetCode> {
  String _signature;
  String _code;
  @override
  void  initState(){
    super.initState();
    SmsAutoFill().listenForCode;
  }

  @override
  void codeUpdated() {
    setState(() {
      _code = SmsAutoFill().code as String;
    });
    //maybe non serve a niente setState
    //maybe il setState fa partire il onCodeChange del Widget e non serve chiamare code checker
    codeChecker(SmsAutoFill().code as String);
  }

  void codeChecker(String code) async{
      _signature = await SmsAutoFill().getAppSignature;
      setState((){});
      if(widget.code == code || Constants.debug){
        BlocProvider.of<BackdropBloc>(context).dispatch(NavigateEvent(global.Constants.dailyCalendarRoute,Utils.formatDate(DateTime.now())));
      }
  }
  void sendMail(){int a=4;}
  void sendMessage(){int a=4;}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Reset'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                  height: 10.0
              ),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "a@gmail.it",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.email),
                    onPressed: (){sendMail();}
                  ),
                ),
              ),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "333 895 2549",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.phone_android),
                    onPressed: (){sendMessage();}
                  ),
                ),
              ),
              SizedBox(
                  height: 50.0
              ),
              PinFieldAutoFill(
                decoration: UnderlineDecoration(
                    textStyle: TextStyle(fontSize: 20, color: Colors.black)),
                onCodeSubmitted: codeChecker,
                codeLength: 6//code length, default 6
              ),
              Spacer(),
              Divider(
                  height: 10.0
              ),
              SizedBox(
                  height: 4.0
              ),
              Text("App Signature : $_signature"),
              SizedBox(
                  height: 4.0
              ),
            ],
          ),
        ),
      ),
    );
  }
}
