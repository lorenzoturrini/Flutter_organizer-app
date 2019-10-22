import 'package:flutter/material.dart';
//import 'package:flutter_web/material.dart';
import 'package:venturiautospurghi/utils/global_contants.dart';
import 'package:venturiautospurghi/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final tabellaUtenti = 'Utenti';

class Profile extends StatefulWidget {
  @override
  State createState() => new _ProfileState();
}

void inputData() async {
  final FirebaseUser user = await _auth.currentUser();
  final uid = user.uid;
  // here you write the codes to input the data into firestore
}

class _ProfileState extends State<Profile> {
  Size deviceSize;

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return new Scaffold(
        appBar: new AppBar(
          leading: new BackButton(),
          title: new Text('Profile'),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: new SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //profileHeader(),
              attributiUtente,
            ],
          ),
        )
    );
  }
}

final attributiUtente = new FutureBuilder(
  future: FirebaseAuth.instance.currentUser() ,
  builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
    var user;
    if (snapshot.hasData) {
      return FutureBuilder(
          future: Firestore.instance.collection(tabellaUtenti).where('Email',isEqualTo: snapshot.data.email).getDocuments(),
          builder: (context, AsyncSnapshot<QuerySnapshot> utente) {
            if (utente.hasData) {
              return
                Container(
                  child: Column(
                    children: <Widget>[
                      new ClipPath(
                        clipper: MyClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 10.0, bottom: 100.0),
                        ),
                      ),
                      Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            border: Border.all(
                                width: 6.0, color: Colors.white)),
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                              "https://i.mmo.cm/is/image/mmoimg/bigview/john-doe-foam-latex-mask--mw-117345-1.jpg"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        Text(utente.data.documents[0].data['Nome'] + " "+ utente.data.documents[0].data['Cognome'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: dark, )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        Text(utente.data.documents[0].data['Email'],
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22, color: grey_dark),),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        Text(utente.data.documents[0].data['Codice Fiscale'],
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22, color: grey_dark)),
                      ),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                          Text(utente.data.documents[0].data['Telefono'],
                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22, color: grey_dark))
                      ),
                    ],
                  ),
                );
            }
            else {
              return Text('Loading...');
            }
          }
      );
    }
    else {
      return Text('Loading...');
    }
  },
);

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.45);
    p.arcToPoint(
      Offset(0.0, size.height * 0.45),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}