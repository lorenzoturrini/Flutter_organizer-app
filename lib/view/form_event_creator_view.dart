import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:venturiautospurghi/plugin/dispatcher/platform_loader.dart';
import 'package:venturiautospurghi/utils/global_methods.dart';
import 'package:venturiautospurghi/utils/theme.dart';
import 'package:venturiautospurghi/view/operator_selection_view.dart';
import '../models/event.dart';


class EventCreator extends StatefulWidget {
  Event _event;

  @override
  State<StatefulWidget> createState() {
    return new EventCreatorState();
  }

  EventCreator(this._event) {
    if(this._event == null)_event=new Event.empty();
  }
}

class EventCreatorState extends State<EventCreator> {
  final dateFormat = DateFormat("EEE d MMM y");
  final timeFormat = DateFormat("HH:mm");
  final _formKey = GlobalKey<FormState>();
  final _formDateKey = GlobalKey<FormState>();
  bool _allDayFlag = false;
  int _radioValue = 0;
  List<String> _categoriesN = List();
  List<dynamic> _categoriesC = List();

  @override
  void initState() {
    getCategories();
  }

  @override
  Widget build(BuildContext context) {

    double iconspace = 30.0;//handle

    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        title: new Text('Create New Event'),
        actions: <Widget>[
          new Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(15.0),
            child: new InkWell(
              child: new Text(
                'SAVE',
                style: TextStyle(
                    fontSize: 20.0),
              ),
              onTap: () => _saveNewEvent(context),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new Form(
            key: this._formKey,
            child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Titolo',
                            hintStyle: subtitle,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          initialValue: widget._event.title,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Il campo \'Titolo\' è obbligatorio';
                            }
                            return null;
                          },
                          onSaved: (String value) => widget._event.title = value,
                        ),
                      ),
                      Divider(height: 40, indent: 20, endIndent: 20, thickness: 2, color: grey_light),
                      Row(children: <Widget>[
                        Container(
                          width: iconspace,
                          margin: EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.note, color: dark, size: iconspace,),
                        ),
                        Expanded(
                          child: TextFormField(
                            maxLines: 3,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Aggiungi note',
                              hintStyle: subtitle,
                              border: InputBorder.none,
                            ),
                            initialValue: widget._event.title,
                            validator: (value)=>null,
                            onSaved: (String value) => widget._event.address = value,
                          ),
                        ),
                      ]),
                      Divider(height: 20, indent: 20, endIndent: 20, thickness: 2, color: grey_light),
                      Row(children: <Widget>[
                        Container(
                          width: iconspace,
                          margin: EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.map, color: dark, size: iconspace,),
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Aggiungi posizione',
                              hintStyle: subtitle,
                              border: InputBorder.none,
                            ),
                            initialValue: widget._event.title,
                            validator: (value)=>null,
                            onSaved: (String value) => widget._event.address = value,
                          ),
                        ),
                      ]),
                      Divider(height: 20, indent: 20, endIndent: 20, thickness: 2, color: grey_light),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child:Row(
                          children: <Widget>[
                            Container(
                              width: iconspace,
                              margin: EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.access_time, color: dark, size: iconspace,),
                            ),
                            Expanded(
                              child: Text("Tutto il giorno", style: label),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Switch(value: _allDayFlag, activeColor: dark, onChanged: (v){
                                setState(() {
                                  _allDayFlag = v;
                                });
                              }),
                            )
                          ],
                        ),
                      ),
                      Form(
                        key: _formDateKey,
                        child: Column(children: <Widget>[
                          Row(
                              children: <Widget>[
                                Container(
                                  width: iconspace,
                                  margin: EdgeInsets.only(right: 20.0),
                                ),
                                Expanded(
                                  child: DateTimeField(
                                    decoration: InputDecoration(
                                        hintText: 'Mon 1 Sep 2019',
                                        hintStyle: label,
                                        border: InputBorder.none
                                    ),
                                    style: label,
                                    format: dateFormat,
                                    initialValue: widget._event.start,
                                    readOnly: true,
                                    resetIcon: null,
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
                                    validator: (val){
                                      if (val != null){
                                        widget._event.start = val;
                                        return null;
                                      } else {
                                        return 'Inserisci una data valida';
                                      }
                                    },
                                    onSaved: (DateTime value) => widget._event.start = value,
                                  ),
                                ),
                                Expanded(
                                  child:
                                  new DateTimeField(
                                      decoration: InputDecoration(
                                          hintText: '10:00',
                                          hintStyle: label,
                                          border: InputBorder.none
                                      ),
                                      textAlign: TextAlign.right,
                                      style: label,
                                      format: timeFormat,
                                      initialValue: DateTime(0),
                                      enabled: !_allDayFlag,
                                      readOnly: true,
                                      resetIcon: null,
                                      onShowPicker: (context, currentValue) async {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime(0)),
                                        );
                                        return DateTimeField.convert(time);
                                      },
                                      validator: (val){
                                        if(_allDayFlag)return null;
                                        if (val != null){
                                          return null;
                                        } else {
                                          return 'Inserisci un orario valido';
                                        }
                                      },
                                      onSaved: (DateTime value) => widget._event.start = value!=null?widget._event.start.add(Duration(hours: value.hour, minutes: value.minute)):widget._event.start
                                  ),
                                ),
                              ]),
                          Row(
                            children: <Widget>[
                              Container(
                                width: iconspace,
                                margin: EdgeInsets.only(right: 20.0),
                              ),
                              Expanded(
                                child: DateTimeField(
                                  decoration: InputDecoration(
                                      hintText: 'Mon 1 Sep 2019',
                                      hintStyle: label,
                                      border: InputBorder.none
                                  ),
                                  style: label,
                                  format: dateFormat,
                                  initialValue: widget._event.end,
                                  enabled: !_allDayFlag,
                                  readOnly: true,
                                  resetIcon: null,
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
                                  validator: (val){
                                    if(_allDayFlag)return null;
                                    if ((val != null) && (val.year >= 2015 && val.year <= 3000) && widget._event.start.isBefore(val.add(Duration(days: 1)))) {
                                      widget._event.end = val;
                                      return null;
                                    } else {
                                      return 'Inserisci una data valida';
                                    }
                                  },
                                  onSaved: (DateTime value) => widget._event.end = value,
                                ),
                              ),
                              Expanded(
                                child:
                                new DateTimeField(
                                    decoration: InputDecoration(
                                        hintText: '10:00',
                                        hintStyle: label,
                                        border: InputBorder.none
                                    ),
                                    textAlign: TextAlign.right,
                                    style: label,
                                    format: timeFormat,
                                    initialValue: DateTime(0),
                                    enabled: !_allDayFlag,
                                    readOnly: true,
                                    resetIcon: null,
                                    onShowPicker: (context, currentValue) async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime(0)),
                                      );
                                      return DateTimeField.convert(time);
                                    },
                                    validator: (val){
                                      if(_allDayFlag)return null;
                                      if (widget._event.start.isBefore(widget._event.end.add(Duration(hours: val.hour, minutes: val.minute)))) {
                                        return null;
                                      } else {
                                        return 'Inserisci un orario valido';
                                      }
                                    },
                                    onSaved: (DateTime value) => widget._event.end = value!=null?widget._event.end.add(Duration(hours: value.hour, minutes: value.minute)):widget._event.end
                                ),
                              )
                            ],
                          ),
                        ],),
                      ),
                      Divider(height: 20, indent: 20, endIndent: 20, thickness: 2, color: grey_light),
                      Row(children: <Widget>[
                        Container(
                          width: iconspace,
                          margin: EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.work, color: dark, size: iconspace,),
                        ),
                        Expanded(
                            child: Text("Aggiungi operatore", style: label)
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: dark),
                          onPressed: () async {
                            if(!_formDateKey.currentState.validate()) return Fluttertoast.showToast(
                                msg: "Inserisci un intervallo temporale valido",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            var result = await PlatformUtils.navigator(context, new OperatorSelection(widget._event.start, widget._event.end));
                            print(result);//TODO
                          },
                        )
                      ]),
                      Divider(height: 20, indent: 20, endIndent: 20, thickness: 2, color: grey_light),
                    ])
            )
        ),
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  getCategories() async {
    PlatformUtils.fireDocument("Costanti","Categorie").then((doc){
      if(doc.exists && doc != null){
        dynamic data = PlatformUtils.getFireDocumentField(doc, null);
        setState(() {
          _categoriesN = data.keys.toList();
          _categoriesC = data.values.toList();
        });
      }
    });
  }


  Future _saveNewEvent(BuildContext context) async {
    if (this._formDateKey.currentState.validate() && this._formKey.currentState.validate()) {
      _formDateKey.currentState.save();
      _formKey.currentState.save();
      //TODO controllo sugli operatori
      print( widget._event.start);
      print( widget._event.end);
      print("Firebase save");
      widget._event.category = _categoriesN[_radioValue];
      widget._event.color = _categoriesC[_radioValue];
      if(_allDayFlag)widget._event.end = widget._event.start;
      PlatformUtils.fire.collection("Eventi").add(widget._event.toDocument());
      Utils.notify();
      Navigator.maybePop(context);
    }
  }

}