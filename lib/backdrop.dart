// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:venturiautospurghi/utils/global_contants.dart' as global;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'models/event_model.dart';
import 'utils/theme.dart';
import 'event_creator.dart';
import 'global_calendar_view.dart';
import 'daily_calendar_view.dart';
import 'operator_list.dart';
import 'reset_code_view.dart';
import 'user_profile.dart';
import 'backdrop.dart';
import 'log_in_view.dart';
import 'event_view.dart';

//HANDLE cambia questa velocità
const double _kFlingVelocity = 2.0;

/// Builds a Backdrop.
///
/// A Backdrop widget has two layers, front and back. The front layer is shown
/// by default, and slides down to show the back layer, from which a user
/// can make a selection. We can configure a custom interchangable title
/// The route selected is notified to the frontlayer
class Backdrop extends StatefulWidget {
  final String frontLayerRoute;
  final Object frontLayerArg;
  final Function backLayerRouteChanger;

  const Backdrop({
    @required this.backLayerRouteChanger,
    @required this.frontLayerRoute,
    @required this.frontLayerArg,
  })  : assert(frontLayerRoute != null),
        assert(backLayerRouteChanger != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: "Backdrop");
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 100), value: 1.0, vsync: this);
  }

  @override
  void didUpdateWidget(Backdrop old) {
    print(widget.frontLayerArg);
    print("backdrop up");
    super.didUpdateWidget(old);
    if (widget.frontLayerRoute != old.frontLayerRoute) {
      _toggleBackdropLayerVisibility(true);
    }/* else if (!_frontLayerVisible) {
      _controller.fling(velocity: _kFlingVelocity);
    }*/
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

      //MAIN BUILEDER METHODS
        //--APPBAR DELLA BACKDROP
  //TODO spostare il controllo della route dal FrontLayer alla backdrop per fare il Fab custom
  @override
  Widget build(BuildContext context) {
    print(widget.frontLayerArg);
    print("backdrop rebuild");
    return Scaffold(
      appBar: AppBar(
        title: new Text("Backdrop"),//TODO decidere se volete il nome della pagina o che cambia se hai il menu aperto
        elevation: 0.0,
        leading: new IconButton(
          onPressed: ()=>_toggleBackdropLayerVisibility(true),
          icon: new AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _controller.view,
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.account_circle,
              semanticLabel: 'login',
            ),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(global.Constants.profileRoute,
                      (Route<dynamic> route) => true);
            },
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onFabClicked,
        child: new Icon(Icons.add),
      ),
      body: LayoutBuilder(
        builder: _buildStack2,
      ),
    );
  }

      //--BUILDER DELL' OVERLAP DEI DUE LAYER
  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0; //HANDLE
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, layerTop, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);
    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          child: _BackLayer(
              onTap: widget.backLayerRouteChanger,
              currentViewR: widget.frontLayerRoute,
          ),
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            onTap: ()=>_toggleBackdropLayerVisibility(false),
            flag: _frontLayerVisible,
            route: widget.frontLayerRoute,
            arguments: widget.frontLayerArg
          ),
        ),
      ],
    );
  }
  Widget _buildStack2(BuildContext context, BoxConstraints constraints) {
    print(widget.frontLayerArg);
    print("backdrop top");
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    const header_height = 32.0;
    final height = constraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    Animation<RelativeRect> layerAnimation = new RelativeRectTween(
        begin: new RelativeRect.fromLTRB(
            0.0, backPanelHeight, 0.0, frontPanelHeight),
        end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(new CurvedAnimation(
        parent: _controller, curve: Curves.linear));

    return Container(
      child: Stack(
        key: _backdropKey,
        children: <Widget>[
          ExcludeSemantics(
            child: _BackLayer(
              onTap: widget.backLayerRouteChanger,
              currentViewR: widget.frontLayerRoute,
            ),
            excluding: _frontLayerVisible,
          ),
          PositionedTransition(
            rect: layerAnimation,
            child:  _FrontLayer(
                onTap: ()=>_toggleBackdropLayerVisibility(false),
                flag: _frontLayerVisible,
                route: widget.frontLayerRoute,
                arguments: widget.frontLayerArg
            ),
          ),
        ],
      ),
    );
  }

      //METODI DI UTILITY
  //TODO make it custom
  void _onFabClicked() {
    DateTime _createDateTime = new DateTime.now();

    Event _event = new Event("", "",_createDateTime,_createDateTime, "", "");

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => EventCreator(_event)
    )
    );
  }

      //METODI DI UTILITY
  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility(bool button) {
    if (button || !_frontLayerVisible) {
      _controller.fling(velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
    }
  }
}

//////THIS CLASS IS CUSTOM POSSIAMO ELIMINARLA SE NON SERVE//////
class _CustomTitle extends AnimatedWidget {
  final Widget frontTitle;
  final Widget backTitle;

  const _CustomTitle({
    Key key,
    Listenable listenable,
    @required this.frontTitle,
    @required this.backTitle,
  })
      : assert(frontTitle != null),
        assert(backTitle != null),
        super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.listenable;

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: CurvedAnimation(
            parent: ReverseAnimation(animation),
            curve: Interval(0.5, 1.0),
          ).value,
          child: FractionalTranslation(
            translation: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(0.5, 0.0),
            ).evaluate(animation),
            child: Semantics(
                label: 'hide categories menu',
                child: ExcludeSemantics(child: backTitle)
            ),
          ),
        ),
        Opacity(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Interval(0.5, 1.0),
          ).value,
          child: FractionalTranslation(
            translation: Tween<Offset>(
              begin: Offset(-0.25, 0.0),
              end: Offset.zero,
            ).evaluate(animation),
            child: Semantics(
                label: 'show categories menu',
                child: ExcludeSemantics(child: frontTitle)
            ),
          ),
        ),
      ],
    );
  }
}
/////////////////////////////////////////////////////////////////
/// Builds a BackLayer.
///
/// The backlayer contains the menu with all the choices of the user
///
///
///
class _BackLayer extends StatelessWidget {
  //ROUTES
  final Map<String,String> _menuResponsabile = const {
    "Incarichi attivi":"/event_view",
    "Operatori ":"/op_list",
    "Calendario generale":"/global_calendar",
    "Creazione nuovo utente":"/",
    "Impostazioni":"/",
    "Statistiche":"/"
  };

  final Map<String,String> _menuOperatore = const {
    "Impegni del giorno":"",
    "Incarichi non letti":"/",
    "Calendario":"/daily_calendar",
    "Impostazioni":"/",
    "Statistiche":"/"
  };

  const _BackLayer({
    Key key,
    this.onTap,
    this.currentViewR,
  })  : assert(currentViewR != null),
        super(key: key);

  final ValueChanged<String> onTap;
  final String currentViewR;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dark,
      child: new ListView(
          children: (global.isSupervisor?_menuResponsabile:_menuOperatore)
          .map((title, route) => _buildMenu(title, route, context)).values.toList()
      ),
    );
  }

  //TODO aspettanndo il layout di Turro
  MapEntry<String,Widget> _buildMenu(String view, String route, BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new MapEntry(view,GestureDetector(
      onTap: () => onTap(route),
      child: currentViewR == route
          ? Column(
        children: <Widget>[
          SizedBox(height: 16.0),
          Center(child:
            Text(
              view,
              style: title_rev
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            width: 70.0,
            height: 2.0,
            color: white,
          ),
        ],
      )
          : Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child:
        Text(
          view,
          style: title_rev
        ),
        ),
      ),
    ));
  }
}

/// Builds a FrontLayer.
///
/// The frontlayer contains the page associated with the selected route.
/// and the UI specific for the role of the user.
/// L'onTap chiude il menu a discesa
/// La route viene gestita in modo da caricare la classe corretta in base
/// al rouolo dell' utente
//TODO rounded corner da decidere aspettando il layout di Turro
class _FrontLayer extends StatelessWidget {
  const _FrontLayer({
    Key key,
    this.onTap,
    this.flag,
    this.route,
    this.arguments,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool flag;
  final String route;
  final Object arguments;

  Widget router(){
    print(arguments);
    print(route);
    print("frontlayer");
    switch(route) {
      case global.Constants.globalCalendarRoute: {return GlobalCalendar();}
      break;
      case global.Constants.dailyCalendarRoute: {return DailyCalendar();}
      break;
      case global.Constants.profileRoute: {return ProfilePage();}
      break;
      case global.Constants.operatorListRoute: {return OperatorList();}
      break;
      case global.Constants.eventViewRoute: {return arguments!=null?EventView(event: arguments):null;}
      break;
      case global.Constants.eventCreatorRoute: {return EventCreator(null);}
      break;
      default: {return DailyCalendar();}
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        router(),
        Visibility(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 40.0,
              alignment: AlignmentDirectional.centerStart,
            ),
          ),
          visible: !flag,
          maintainSize: false,
        )
      ],
    );
  }
}