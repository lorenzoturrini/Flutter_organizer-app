import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venturiautospurghi/bloc/backdrop_bloc/backdrop_bloc.dart';
import 'package:venturiautospurghi/bloc/operators_bloc/operators_bloc.dart';
import 'package:venturiautospurghi/models/user.dart';
import 'package:venturiautospurghi/utils/global_methods.dart';
import 'package:venturiautospurghi/utils/global_contants.dart' as global;
import 'package:venturiautospurghi/utils/theme.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:venturiautospurghi/view/splash_screen.dart';

class OperatorList extends StatefulWidget {
  OperatorList({ Key key }) : super(key: key);
  @override
  _OperatorListState createState() => new _OperatorListState();

}

class _OperatorListState extends State<OperatorList>{
  final dateFormat = DateFormat("dd-MM-yy");
  final timeFormat = DateFormat("h:mm a");
  final _filtersKey = new GlobalKey<FormState>();
  final TextEditingController _stringFilter = new TextEditingController();
  DateTime _dateFilter = Utils.formatDate(DateTime.now(), "day");
  bool _filters = false;
  bool ready = false;

  _SearchListState() {
    _stringFilter.addListener(() {
      if (_stringFilter.text.isEmpty) {
        BlocProvider.of<OperatorsBloc>(context).dispatch(ApplyOperatorFilterString(null));
      }
      else {
        BlocProvider.of<OperatorsBloc>(context).dispatch(ApplyOperatorFilterString(_stringFilter.text));
      }
    });
  }

  @override
  void initState() {
    _SearchListState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperatorsBloc, OperatorsState>(
      builder: (context, state) {
        if (state is Loaded) {
          //get data
          BlocProvider.of<OperatorsBloc>(context).dispatch(ApplyOperatorFilters(null,null));
          ready = true;
        }else if(state is Filtered && ready){
          return Material(
            elevation: 12.0,
            borderRadius: new BorderRadius.only(
                topLeft: new Radius.circular(16.0),
                topRight: new Radius.circular(16.0)),
            child: Column(
              children: <Widget>[
                SizedBox(height: 8.0),
                logo,
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: searchBar()
                ),
                Visibility(
                  child: filtersBox(),
                  visible: _filters,
                ),
                Expanded(
                  child: ListView(
                    padding: new EdgeInsets.symmetric(vertical: 8.0),
                    children: state.operators.map((contact) => new ChildItem(contact)).toList(),
                  ),
                )
              ],
          )
          );
        }
        return SplashScreen();
      }
  );
  }

  Widget searchBar() {
    return DecoratedBox(
        decoration: BoxDecoration(
            color: dark,
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                style: new TextStyle(color: white),
                controller: _stringFilter,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: new Icon(Icons.search, color: white,),
                  hintText: "Cerca un operatore",
                ),
              ),
            ), IconButton(
              icon: new Icon((!_filters)?Icons.tune:Icons.keyboard_arrow_up, color: white),
              onPressed: (){setState(() {
                _filters = !_filters;
              });},
            ),
          ],
        )

    );
  }

  Widget filtersBox() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical:8.0, horizontal:16.0),
        padding: const EdgeInsets.only(top:16.0, right:16.0, bottom:4.0, left:16.0),
        decoration: BoxDecoration(
            color: dark,
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Icon(Icons.tune),
                Text("FILTRA PER OPEARATORI LIBERI",style: subtitle_rev),
                //Align(alignment: Alignment.topRight, child: Icon(Icons.keyboard_arrow_up))
              ],),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Form(
                  key: this._filtersKey,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      Container(
                        width: 140,
                        child: DateTimeField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(borderSide: BorderSide(width: 0.0, style: BorderStyle.none))
                          ),
                          style: subtitle_rev,
                          format: dateFormat,
                          initialValue: _dateFilter,
                          enabled: true,
                          readOnly: true,
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: Utils.formatDate(DateTime.now(), "day"),
                                initialDate: currentValue!=null?currentValue.year>2000?currentValue:
                                DateTime(2000+currentValue.year, currentValue.month, currentValue.day, currentValue.hour, currentValue.minute)
                                    :Utils.formatDate(DateTime.now(), "day"),
                                lastDate: DateTime(3000)
                            );
                          },
                          onSaved: (DateTime value) => _dateFilter = value!=null?value.year>2000?value:
                          DateTime(2000+value.year, value.month, value.day, value.hour, value.minute):Utils.formatDate(DateTime.now(), "day"),
                        )
                      ),
                      Icon(Icons.access_time),
                      Container(
                        width: 140,
                        child: DateTimeField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(borderSide: BorderSide(width: 0.0, style: BorderStyle.none))
                          ),
                          style: subtitle_rev,
                          format: timeFormat,
                          initialValue: DateTime(0),
                          enabled: true,
                          readOnly: true,
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime(0)),
                            );
                            return DateTimeField.convert(time);
                          },
                          onSaved: (DateTime value) => _dateFilter = value!=null?_dateFilter.add(Duration(hours: value.hour, minutes: value.minute)):_dateFilter
                          ),
                      ),
                    ],
                  )
                )
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    child: new Text('APPLICA', style: subtitle_rev),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    elevation: 15,
                    onPressed: () => _applyFilters(),
                  )
              )
            ]
        )
    );
  }

  Future _applyFilters() async {
    if (this._filtersKey.currentState.validate()) {
      _filtersKey.currentState.save();
      _filters = false;
      print(_dateFilter);
      BlocProvider.of<OperatorsBloc>(context).dispatch(ApplyOperatorFilterDate(_dateFilter));
    }
  }
}

class ChildItem extends StatelessWidget {
  final Account operator;
  ChildItem(this.operator);
  @override
  Widget build(BuildContext context) {
    //TODO add icons by account's properties
    return GestureDetector(
      onTap: ()=>BlocProvider.of<BackdropBloc>(context).dispatch(NavigateEvent(global.Constants.dailyCalendarRoute,[operator,null])),
      child: Container(
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
            Text(operator.surname.toUpperCase()+" ", style: title),
            Text(operator.name, style: subtitle),
            Expanded(child: Container(),),
            Icon(Icons.local_shipping, color: dark,)
          ],
        ),
      ),
    );
  }

}