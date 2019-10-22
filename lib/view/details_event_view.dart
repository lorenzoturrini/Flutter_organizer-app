import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:venturiautospurghi/bloc/backdrop_bloc/backdrop_bloc.dart';
import 'package:venturiautospurghi/utils/global_contants.dart' as global;
import 'package:venturiautospurghi/utils/global_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:venturiautospurghi/view/widget/fab_widget.dart';
import 'package:venturiautospurghi/view/widget/switch.dart';
import '../utils/theme.dart';
import '../models/event.dart';

class DetailsEvent extends StatefulWidget {
  final Event event;
  final bool isSupervisor;

  DetailsEvent(@required this.event, @required this.isSupervisor, {Key key,})  : assert(event != null),
        super(key: key);

  @override
  _DetailsEventState createState()=>_DetailsEventState();
}

class _DetailsEventState extends State<DetailsEvent> with TickerProviderStateMixin {
  String dateToText = "";
  final List<Tab> tabsHeaders = <Tab>[
    new Tab(text: "DETTAGLIO"),
    new Tab(text: "DOCUMENTI"),
    new Tab(text: "NOTE")
  ];
  List<Widget> tabsContents = List();
  TabController _tabController;
  Color c = Color(global.Constants.fallbackColor);
  String operators;

  @override
  void initState() {
    super.initState();
    tabsContents = _buildTabsContents();
    _tabController = new TabController(vsync: this, length: tabsHeaders.length);
    getColor();
    getDate(widget.event.start);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _buildTabsContents(){
    double padding = 10.0; //HANDLE
    List<Widget> t = List();

    //TODO fill all field with right content
    Widget detailsContet = Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal:40.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.clock, size: 25,),
                SizedBox(width: padding,),
                Text("0-10", style: subtitle_rev)
              ],
            ),
          ),
          Divider(height: 2, thickness: 2, indent: 35, color: almost_dark,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.map, size: 25,),
                SizedBox(width: padding,),
                Text("0-10", style: subtitle_rev)
              ],
            ),
          ),
          Divider(height: 2, thickness: 2, indent: 35, color: almost_dark,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.truck, size: 25,),
                SizedBox(width: padding,),
                Text("0-10", style: subtitle_rev)
              ],
            ),
          ),
          Divider(height: 2, thickness: 2, indent: 35, color: almost_dark,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.hardHat, size: 25,),
                SizedBox(width: padding,),
                Text("0-10", style: subtitle_rev)
              ],
            ),
          ),
          Divider(height: 2, thickness: 2, indent: 35, color: almost_dark,),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(FontAwesomeIcons.clipboard, size: 25,),
                SizedBox(width: padding,),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("0-10", style: subtitle_rev, overflow: TextOverflow.ellipsis,),
                      FlatButton(
                        child: Text("LEGGI", style: subtitle_rev,),
                        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        color: c,
                        onPressed: ()=>_tabController.animateTo(2),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    Widget detailsDocument = Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal:40.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.file, size: 30, color: dark,),
                  SizedBox(width: padding,),
                  Text("0-10", style: subtitle.copyWith(color: dark))
                ],
              ),
            ),
          )
        ],
      ),
    );

    Widget detailsNote = Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal:40.0),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(FontAwesomeIcons.clipboard, size: 30,),
                  SizedBox(width: padding,),
                  new Expanded(
                    flex: 1,
                    child: new SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                        child: new Text("riautospurgh(26111): Accessing hidden method Ljava/security/spec/ECParameterSpec;->setCurveName(Ljava/lang/String;)V (greylist, reflection, allowed)"
                        "W/turiautospurgh(26111):", style: subtitle_rev),
                    )
                  )
                ],
              ),
            ),
        ],
      )
    );


    t.add(detailsContet);
    t.add(detailsDocument);
    t.add(detailsNote);
    return t;
  }



  //MAIN BUILEDER METHODS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Intervento'),
            leading: IconButton(icon:Icon(Icons.arrow_back, color: white),
              onPressed:() => Navigator.pop(context, false),
            )
        ),
        floatingActionButton: Fab(context).FabChooser(global.Constants.detailsEventViewRoute, widget.isSupervisor),
        body: Material(
            elevation: 12.0,
            child: Stack(
                children: <Widget>[
                  Container(
                      child: Column(
                          children: <Widget>[Expanded(
                            flex: 6,
                            child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Container(color: dark),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(color: c),
                                  )
                                ]
                            ),
                          ),Expanded(
                            flex: 4,
                            child: Container(color: grey),
                          )
                          ]
                      )
                  ),
                  Container(
                      child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: c,
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0))
                              ),
                              height: 100,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: dark,
                                          borderRadius: BorderRadius.all(Radius.circular(25.0))
                                      ),
                                      width: 45,
                                      height: 80,
                                      padding: EdgeInsets.only(right: 5),
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Center(
                                        child: Text(dateToText, style: title_rev.copyWith(fontSize: 18)),
                                      )
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 20),
                                      Text(widget.event.title.toUpperCase(), style: title),
                                      Text(widget.event.category.toUpperCase(), style: subtitle.copyWith(color: dark)),
                                    ],
                                  )
                                ],
                              ),
                            ),Expanded(
                              child:Row(
                                children: <Widget>[
                                  Expanded(
                                    child:Container(
                                      decoration: BoxDecoration(
                                          color: dark,
                                          borderRadius: BorderRadius.all(Radius.circular(40.0))
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 20,),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: whitebackground,
                                                borderRadius: BorderRadius.all(Radius.circular(30.0))
                                            ),
                                            child: new TabBar(
                                              isScrollable: true,
                                              unselectedLabelColor: Colors.grey,
                                              labelColor: Colors.white,
                                              indicatorSize: TabBarIndicatorSize.tab,
                                              indicator: new BubbleTabIndicator(
                                                indicatorHeight: 40.0,
                                                indicatorColor: c,
                                                tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                              ),
                                              tabs: tabsHeaders,
                                              controller: _tabController,
                                            ),
                                          ),Expanded(
                                            child: new TabBarView(
                                              controller: _tabController,
                                              children: tabsContents.map((Widget tab) {
                                                return tab;
                                              }).toList(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 10,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        color: c,
                                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 65,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 30,),
                                  Icon(Icons.notifications, size: 40,),
                                  Text("Avvisami (15m)", style: subtitle_rev),
                                  SizedBox(width: 30),
                                  Switch(value: true, activeColor: c, onChanged: (v){})//TODO
                                ],
                              ),
                            )
                          ]
                      )
                  ),
                ]
            )
        )
    );
  }
  void getDate(DateTime d) async{
    initializeDateFormatting("it_IT", null).then((_){
      var formatter = new DateFormat(' MMM\n  d\n E');
      String formatted = formatter.format(d);
      setState(() {
        dateToText = formatted;
      });
    });
  }

  void getColor() async {
    var a = await Utils.getColor(widget.event.category);
    if(c!=a){
      setState((){
        c=a;
      });
    }
  }
}