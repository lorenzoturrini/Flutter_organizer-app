import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_auth/fb_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:venturiautospurghi/models/user.dart';
import 'package:venturiautospurghi/utils/global_methods.dart';
import 'package:venturiautospurghi/utils/theme.dart';

final _auth = FBAuth();

class Register extends StatefulWidget {
  final String title = 'Registration';
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cognomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _codFiscaleController = TextEditingController();
  int _radioValue = 0;
  bool _success;
  String _userEmail;
  String _errMsg = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child:Column(
              children:<Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(FontAwesomeIcons.hardHat, color: yellow, size: 80,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: dark,
                  ),
                ),
                SizedBox(height: 10,),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(hintText: "Nome", hintStyle: subtitle, border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Il campo \'Nome\' è obbligatorio';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _cognomeController,
                        decoration: InputDecoration(hintText: 'Cognome', hintStyle: subtitle, border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Il campo \'Cognome\' è obbligatorio';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(hintText: 'Email', hintStyle: subtitle, border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Il campo \'Email\' è obbligatorio';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                          controller: _telefonoController,
                          decoration: InputDecoration(hintText: 'Telefono', hintStyle: subtitle, border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Il campo \'Telefono\' è obbligatorio';
                            } else if (!Utils.isNumeric(value)) {
                              return 'Inserisci un valore valido';
                            }
                            return null;
                          }
                      ),
                      TextFormField(
                        controller: _codFiscaleController,
                        decoration: InputDecoration(hintText: 'Codice Fiscale', hintStyle: subtitle, border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Il campo \'Codice Fiscale\' è obbligatorio';
                          }else if (value.length != 16){
                            return 'Inserisci un valore valido';
                          }
                          return null;
                        },
                      ),Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    color: (_radioValue==0)?dark:white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: dark)
                                ),
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                    children: <Widget>[
                                      new Radio(
                                        value: 0,
                                        activeColor: almost_dark,
                                        groupValue: _radioValue,
                                        onChanged: _handleRadioValueChange,
                                      ),
                                      new Text('Operatore', style: (_radioValue==0)?subtitle_rev:subtitle.copyWith(color: dark)),
                                    ]
                                )
                            ),
                            SizedBox(width: 30,),
                            Container(
                                decoration: BoxDecoration(
                                    color: (_radioValue==1)?dark:white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: dark)
                                ),
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                    children: <Widget>[
                                      new Radio(
                                        value: 1,
                                        activeColor: almost_dark,
                                        groupValue: _radioValue,
                                        onChanged: _handleRadioValueChange,
                                      ),
                                      new Text('Responsabile', style: (_radioValue==1)?subtitle_rev:subtitle.copyWith(color: dark)),
                                    ]
                                )
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        alignment: Alignment.topRight,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            RaisedButton(
                            color: dark,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            onPressed: ()=>Navigator.of(context).pop(),
                            child: Text('ANNULLA', style: title_rev),
                          ),SizedBox(
                              width: 20
                            ),
                            RaisedButton(
                              color: dark,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _register();
                                }
                              },
                              child: Text('CONFERMA', style: title_rev),
                            ),
                          ],
                        )
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(_success == null
                            ? ''
                            : (_success
                            ? 'Utente '+_userEmail+' registrato con successo.'
                            : _errMsg), style: _success!=null && _success?label:error,),
                      )
                    ],
                  ),
                ),
              ]
          ),
        )
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    super.dispose();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  // Example code for registration.
  void _register() async {
    _auth.createAccount(_emailController.text,"letstry",
        displayName: _cognomeController.text+" "+_nomeController.text,
    ).then((user){
      if (user != null) {
        _auth.forgotPassword(_emailController.text);
        createUser(user.uid, _nomeController.text, _cognomeController.text, _emailController.text, _telefonoController.text, _codFiscaleController.text, (_radioValue==0)?false:true);
        setState(() {
          _success = true;
          _userEmail = user.email;
          _errMsg = "";
        });
      } else {
        setState(() {
          _success = false;
          _errMsg = "Qualcosa è andato storto";
        });
      }
    }).catchError((e){
        setState(() {
          _success = false;
          _errMsg = e.toString().split(",")[1];
        });
    });

  }

  Future<Account> createUser(String uid, String nome, String cognome, String email, String telefono, String codFiscale, bool responsabile) async {
      Firestore.instance.collection("Utenti").document(uid).setData(Account(uid,nome,cognome,email,telefono,codFiscale,[],"",false,responsabile).toMap());
      var dataMap = new Map<String, dynamic>();
      dataMap['CodiceFiscale'] = codFiscale;
      dataMap['Cognome'] = cognome;
      dataMap['Email'] = email;
      dataMap['Nome'] = nome;
      dataMap['Responsabile'] = responsabile;
      dataMap['Telefono'] = telefono;
  }

}