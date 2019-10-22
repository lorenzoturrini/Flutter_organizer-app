import 'package:fb_auth/fb_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venturiautospurghi/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:venturiautospurghi/bloc/backdrop_bloc/backdrop_bloc.dart';
import 'package:venturiautospurghi/utils/global_contants.dart' as global;
import 'package:venturiautospurghi/utils/theme.dart';
import 'package:venturiautospurghi/view/widget/responsive_widget.dart';

final _auth = FBAuth();

class LoginData {
  String email = '';
  String password = '';
}

class LogIn extends StatefulWidget {

  const LogIn();

  @override
  State createState() => new _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  String _userEmail;
  LoginData _data = new LoginData();
  bool _isLoading = false;

  String validateEmail(String value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'The E-mail Address must be a valid email address.';
    }
    return null;
  }

  void _navigateToReset() {
    BlocProvider.of<BackdropBloc>(context).dispatch(
        NavigateEvent(global.Constants.resetCodeRoute, null));
  }

  @override
  Widget build(BuildContext context) {
    final emailWidget = new Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.person_outline,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: TextFormField(
              controller: _emailController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );

    final passwordWidget = new Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin:
      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.lock_open,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term) => {this._signInWithEmailAndPassword()},
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your password',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );

    final loginButton = new Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              splashColor: Colors.white,
              color: dark,
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  new Expanded(
                    child: Container(),
                  ),
                  new Transform.translate(
                    offset: Offset(10.0, 0.0),
                    child: new Container(
                      padding: const EdgeInsets.all(5.0),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                            new BorderRadius.circular(45.0)),
                        splashColor: dark,
                        color: white,
                        child: Icon(
                          Icons.arrow_forward,
                          color: dark,
                        ),
                        onPressed: () => {this._signInWithEmailAndPassword()},
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () => {this._signInWithEmailAndPassword()},
            ),
          ),
        ],
      ),
    );

    final resetPasswordText = new GestureDetector(
      onTap: () {
        _formKey.currentState.save();
        String resetMessage;
        if (_data.email.isEmpty) {
          resetMessage = 'Please enter an email address.';
        } else {
          resetMessage = 'Reset password for ' + _data.email;
          resetMessage +=
          ". Manda all'altra view o un identificativo dell'utente o già mail e telefono in modo che i campi siano già compilati";
        }

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new AlertDialog(
                title: new Text('Reset Password'),
                content: new Text(resetMessage),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        if (_data.email.isNotEmpty) {
                          _navigateToReset();
                        }
                        Navigator.of(context).pop(false);
                      },
                      child: new Text('OK')
                  ),
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: new Text("CANCEL"),
                  )
                ],
              );
            }
        );
      },
      child: new Text('Reset Password', textAlign: TextAlign.center,
        style: new TextStyle(fontSize: 18.0, color: Colors.black54),
      ),
    );

    final loadingSpinner = new Center(
      heightFactor: null,
      widthFactor: null,
      child: new CircularProgressIndicator(),
    );

    Widget content = Padding(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        children: <Widget>[
          logo,
          new Form(
            key: this._formKey,
            child: new Column(
              children: <Widget>[
                emailWidget,
                SizedBox(height: 8.0),
                passwordWidget,
              ],
            ),
          ),
          SizedBox(height: 08.0),
          _isLoading || _success ? loadingSpinner :
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              loginButton,
            ],
          ),
          SizedBox(height: 30.0),
          resetPasswordText,
        ],
      ),
    );

    return new Scaffold(
        backgroundColor: white,
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 8,
                width: double.infinity,
                color: dark,
                child: CustomPaint(
                    painter: PathPainter(),
                    child: Container()
                ),
              ),SizedBox(height: 10.0,), ResponsiveWidget(
                  largeScreen: Align(alignment: Alignment.topCenter,
                    child: Container(
                      width: 1000,
                      child: content,
                    ),),
                  smallScreen: content
              )
            ],
          ),
        )
    );
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() async {
    //enable loading
    setState(() {
      _isLoading = true;
    });
    final AuthUser user = (await _auth.login(
        _emailController.text, _passwordController.text));
    if (user != null) {
      //enable loading
      setState(() {
        _success = true;
        _isLoading = false;
      });
      //this set the user info into a global state (main)
      BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn(user));
    } else {
      //disable loading
      setState(() {
        _success = false;
        _isLoading = false;
      });
    }
  }
}

class PathPainter extends CustomPainter {
  int span = -1;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0,size.height-span);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height-span);
    canvas.drawPath(path, paint);
    if(span>0)canvas.drawRect(Rect.fromLTRB(0, size.height-span, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}