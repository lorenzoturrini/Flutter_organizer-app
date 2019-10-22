import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:venturiautospurghi/models/user.dart';
import 'package:venturiautospurghi/utils/global_contants.dart' as global;
import 'package:venturiautospurghi/view/widget/switch.dart';
import '../utils/theme.dart';

class OperatorSelection extends StatefulWidget {
  final DateTime start;
  final DateTime end;

  OperatorSelection(@required this.start, @required this.end, {Key key,})  :
        assert(start != null),
        assert(end != null),
        super(key: key);

  @override
  _OperatorSelectionState createState()=>_OperatorSelectionState();
}

class _OperatorSelectionState extends State<OperatorSelection>{
  List<Account> operators = [];
  Map<String,bool> sel = Map();
  bool superChecked = false;

  @override
  void initState() {
    super.initState();
    //query operators list
    Account a = Account.empty();
    a.id = "12";
    Account b = Account.empty();
    b.id = "13";
    operators.add(a);
    operators.add(b);
    operators.forEach((a){
      sel[a.id] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Intervento'),
            leading: IconButton(icon:Icon(Icons.arrow_back, color: white),
              onPressed:() => Navigator.pop(context, false),
            )
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          backgroundColor: dark,
          onPressed:(){if(superChecked)Navigator.pop(context, getOperatorsSelected());else
            return Fluttertoast.showToast(
                msg: "Selezione l' operatore principale, tappando due volte",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );},
    ),
        body: Material(
        elevation: 12.0,
        borderRadius: new BorderRadius.only(
            topLeft: new Radius.circular(16.0),
            topRight: new Radius.circular(16.0)),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                children: operators.map((operator) => new ChildItem(operator, sel[operator.id], onTap)).toList(),
              ),
            )
          ],
        )
      )
    );
  }

  bool onTap(Account op){
    print(sel[op.id]);
    setState(() {
      if(sel[op.id]==false) sel[op.id]=true;
      else if(sel[op.id]==true && !superChecked){
        superChecked = true;
        sel[op.id]=null;
      }else{
        if(sel[op.id]==null) superChecked = false;
        sel[op.id]=false;
      }
    });
  }

  List<dynamic> getOperatorsSelected(){
    List<String> selectedSubOperators = [];
    String selectedOperator = null;
    sel.keys.forEach((k){
      if(sel[k] == true) selectedSubOperators.add(k);
      else if(sel[k] == null) selectedOperator = k;
    });
    return [selectedOperator, selectedSubOperators];
  }
}

class ChildItem extends StatelessWidget {
  final Account operator;
  final bool checked;
  final dynamic onTap;

  ChildItem(this.operator, this.checked, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            padding: EdgeInsets.all(2.0),
            child: Icon(Icons.work, color: yellow,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: dark,
            ),
          ),
          Text(operator.surname.toUpperCase() + " ", style: title),
          Text(operator.name, style: subtitle),
          Expanded(child: Container(),),
          CheckboxTriState(onChanged: (v)=>onTap(operator),
            value: checked, tristate: true, activeColor: dark, checkColor: white, superColor: yellow,),
        ],
      ),
    );
  }
}