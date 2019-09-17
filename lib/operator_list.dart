import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venturiautospurghi/utils/global_contants.dart';
import 'package:venturiautospurghi/utils/theme.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';

class OperatorList extends StatefulWidget {
  OperatorList({ Key key }) : super(key: key);
  @override
  _OperatorListState createState() => new _OperatorListState();

}

class _OperatorListState extends State<OperatorList>{
  final dateFormat = DateFormat("dd MM yy");
  final timeFormat = DateFormat("h:mm a");
  final _filtersKey = new GlobalKey<FormState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _IsSearching;
  bool _filters;
  DateTime _filterDate;
  DateTime _filterTime;
  String _searchText = "";

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      }
      else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    _filters = false;
    init();
  }

  void init() {
    _list = List();
    _list.add("Google");
    _list.add("IOS");
    _list.add("Android");
    _list.add("Dart");
    _list.add("Flutter");
    _list.add("Python");
    _list.add("React");
    _list.add("Xamarin");
    _list.add("Kotlin");
    _list.add("Java");
    _list.add("RxAndroid");
  }
  /*
  /////////////////////////////////////////////////////////////////
  CHESSIFA QUI?
  1.Firebase fa UNA richiesta e lavoriamo su un array dato filtrando a posteriori
  2.Firebase fa TANTE richieste quindi i dati arrivano già filtrati e non ci resta che mostrare l'array

  ////////////////////////////////////////////////////////////////
  */

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: whitebackground,
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
            resultList(1)
          ],
        ),
    );
  }


  Widget resultList(int mode) {
    if(mode==1){
      return Expanded(
        child: ListView(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          children: _IsSearching ? _buildSearchList() : _buildList(),
        ),
      );
    }else if(mode == 2){
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${_list[index]}'),
            );
          },
        ),
      );
    }
  }

////METODI PER METODO 1
  List<ChildItem> _buildList() {
    return _list.map((contact) => new ChildItem(contact)).toList();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new ChildItem(contact))
          .toList();
    }
    else {
      List<String> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String  name = _list.elementAt(i);
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return _searchList.map((contact) => new ChildItem(contact))
          .toList();
    }
  }
////END

  Widget searchBar() {
    return DecoratedBox(
        decoration: BoxDecoration(
            color: dark,
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: TextField(
          style: new TextStyle(color: white),
          controller: _searchQuery,
          decoration: InputDecoration(
            prefixIcon: new Icon(Icons.search, color: white,),
            suffixIcon: IconButton(
              icon: new Icon((!_filters)?Icons.tune:Icons.keyboard_arrow_up, color: white),
              onPressed: (){setState(() {
                _filters = !_filters;
              });},
            ),
            hintText: "Cerca un operatore",
          ),
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
                        width: 120,
                        child: DateTimePickerFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide(width: 0.0, style: BorderStyle.none))
                          ),
                          initialDate: DateTime.now(),
                          initialValue: DateTime.now(),
                          keyboardType: TextInputType.datetime,
                          style: subtitle_rev,
                          inputType: InputType.date,
                          format: dateFormat,
                          resetIcon: null,
                          onSaved: (DateTime value)=>setState((){_filterDate = value;}),
                        )
                      ),
                      Icon(Icons.access_time),
                      Container(
                        width: 120,
                        child: DateTimePickerFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide(width: 0.0, style: BorderStyle.none))
                          ),
                          initialDate: DateTime.now(),
                          initialValue: DateTime.now(),
                          keyboardType: TextInputType.number,
                          style: subtitle_rev,
                          inputType: InputType.time,
                          format: timeFormat,
                          resetIcon: null,
                          validator: this._validateFilter,
                          onSaved: (DateTime value)=>setState((){_filterTime = value;}),
                        )
                      )
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

  String _validateFilter(DateTime value) {
    if (value == null) {
      return 'Please enter a valid period';
    } else {
      return null;
    }
  }

  Future _applyFilters() async {
    if (this._filtersKey.currentState.validate()) {
      _filtersKey.currentState.save();
      print("Internal logic stuff(meotdo 1) or Firebase stuff(Metodo 2)");
      //All in _filterDate e _filterTime
      setState(() {
        _filters = false;
      });
      Navigator.maybePop(context);
    }
  }
}

//TODO stile del ChildItem
class ChildItem extends StatelessWidget {
  final String name;
  ChildItem(this.name);
  @override
  Widget build(BuildContext context) {
    return new ListTile(title: new Text(this.name));
  }

}