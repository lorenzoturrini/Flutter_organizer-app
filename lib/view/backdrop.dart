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

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:venturiautospurghi/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:venturiautospurghi/bloc/backdrop_bloc/backdrop_bloc.dart';
import 'package:venturiautospurghi/bloc/events_bloc/events_bloc.dart';
import 'package:venturiautospurghi/bloc/operators_bloc/operators_bloc.dart';
import 'package:venturiautospurghi/models/linkMenu.dart';
import 'package:venturiautospurghi/repository/events_repository.dart';
import 'package:venturiautospurghi/view/splash_screen.dart';
import 'package:venturiautospurghi/view/widget/fab_widget.dart';
import 'package:venturiautospurghi/utils/global_contants.dart' as global;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:venturiautospurghi/view/waiting_event_view.dart';
import 'package:venturiautospurghi/view/widget/persistenNotification_widget.dart';
import '../models/event.dart';
import '../utils/theme.dart';
import 'form_event_creator_view.dart';
import 'monthly_calendar_view.dart';
import 'daily_calendar_view.dart';
import 'operator_list_view.dart';
import 'user_profile_view.dart';
import 'details_event_view.dart';

//HANDLE cambia questa velocità
const double _kFlingVelocity = 2.0;

final Map<String, LinkMenu> _menuOperatore = const {
  global.Constants.homeRoute:
    const LinkMenu(Icons.home, Colors.white, 30, "Home", title_rev),
  global.Constants.waitingEventListRoute:
    const LinkMenu(Icons.visibility_off, Colors.white, 30, "Incarichi in sospeso", title_rev),
  global.Constants.monthlyCalendarRoute:
    const LinkMenu(FontAwesomeIcons.calendarAlt, Colors.white, 25, "Calendario", title_rev)
};

final Map<String, LinkMenu> _menuResponsabile = const {
  global.Constants.homeRoute:
    const LinkMenu(Icons.home, Colors.white, 16, "Home", title_rev),
};

/// Builds a Backdrop.
///
/// A Backdrop widget has two layers, front and back. The front layer is shown
/// by default, and slides down to show the back layer, from which a user
/// can make a selection. We can configure a custom interchangable title
/// The route selected is notified to the frontlayer
class Backdrop extends StatefulWidget {
  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 100), value: 1.0, vsync: this);
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  //MAIN BUILEDER METHODS
  //--APPBAR DELLA BACKDROP
  @override
  Widget build(BuildContext context) {
    final backdropBloc = BlocProvider.of<BackdropBloc>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<EventsBloc>(
          builder: (context) {
            return EventsBloc(eventsRepository: backdropBloc.eventsRepository);
          },
        ),BlocProvider<OperatorsBloc>(
          builder: (context) {
            return OperatorsBloc(eventsRepository: backdropBloc.eventsRepository);
          },

        ),
      ],
      child: BlocBuilder<BackdropBloc, BackdropState>(
        builder: (context, state) {
          if (state is Ready) {
            //in the state there is the subscription to the data to ear for realtime changes
            if(state.subtype==global.Constants.EVENTS_SUB)BlocProvider.of<EventsBloc>(context).dispatch(LoadEvents(state.subscription,state.args));
            else if(state.subtype==global.Constants.OPERATORS_SUB)BlocProvider.of<OperatorsBloc>(context).dispatch(LoadOperators(state.subscription));
            _toggleBackdropLayerVisibility(false);
            return WillPopScope(
                onWillPop: _onBackPressed,
                child: Scaffold(
                appBar: AppBar(
                  title: new Text(
                      (backdropBloc.isSupervisor
                          ? _menuResponsabile[state.route]!=null?_menuResponsabile[state.route]:_menuResponsabile[global.Constants.homeRoute]
                          : _menuOperatore[state.route]!=null?_menuOperatore[state.route]:_menuOperatore[global.Constants.homeRoute])
                          .textLink.toUpperCase(),
                      style: title_rev),
                  elevation: 0.0,
                  leading: new IconButton(
                    onPressed: () => _toggleBackdropLayerVisibility(true),
                    icon: new AnimatedIcon(
                      icon: AnimatedIcons.close_menu,
                      progress: _controller.view,
                    ),
                  ),
                ),
                floatingActionButton: Fab(context).FabChooser(state.route, backdropBloc.isSupervisor),
                body: _buildStack(state.route, state.content)
              )
            );
          }
          if(state is  NotificationWatingEvent){
            return Scaffold(
                appBar: AppBar(
                  leading: new IconButton(
                    icon: Icon(Icons.dehaze)
                  ),
                ),
                body: persistenNotification()
            );
          }
            return Container(
            child: SplashScreen(),
          );
        }
      )
    );
  }

  Widget _buildStack(String frontLayerRoute, dynamic content) {
    const double layerTitleHeight = 64.0;
    final Size layerSize = MediaQuery.of(context).size;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = new RelativeRectTween(
        begin: new RelativeRect.fromLTRB(
            0.0, layerTop-layerTitleHeight, 0.0, -(layerTop-layerTitleHeight)),
        end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(
        new CurvedAnimation(parent: _controller, curve: Curves.linear));
    Animation<RelativeRect> overLayerAnimation = new RelativeRectTween(
        begin: new RelativeRect.fromLTRB(
            0.0, layerTop-layerTitleHeight, 0.0, 0.0),
        end: new RelativeRect.fromLTRB(0.0, layerTop, 0.0, 0.0))
        .animate(
        new CurvedAnimation(parent: _controller, curve: Curves.linear));

    return Container(
      child: Stack(
        children: <Widget>[
          ExcludeSemantics(
            child: _BackLayer(currentViewRoute: frontLayerRoute),
            excluding: _frontLayerVisible,
          ),
          PositionedTransition(
            rect: layerAnimation,
            child:  content
          ),
          PositionedTransition(
            rect: overLayerAnimation,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: ()=>_toggleBackdropLayerVisibility(false),
              child: Container(
                height: 40.0,
              ),
            )
          ),
        ],
      ),
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
      _controller.fling(
          velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Sei sicuro?'),
        content: new Text('Vuoi uscire dall\'app?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("No"),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Si"),
          ),
        ],
      ),
    ) ?? false;
  }
}

/// Builds a BackLayer.
///
/// The backlayer contains the menu with all the choices of the user
///
///
///
class _BackLayer extends StatelessWidget {
  const _BackLayer({
    Key key,
    this.currentViewRoute,
  })  : assert(currentViewRoute != null),
        super(key: key);

  final String currentViewRoute;

  @override
  Widget build(BuildContext context) {

    return Container(
        color: dark,
        child: Column(
          children: <Widget>[
            Expanded(
              child: new ListView(
                  physics: new BouncingScrollPhysics(),
                  children: (BlocProvider.of<BackdropBloc>(context).isSupervisor ? _menuResponsabile : _menuOperatore)
                      .map((route, linkMenu) =>
                      _buildMenu(linkMenu, route, context))
                      .values
                      .toList()),
            ),
            Expanded(
              child: Container(
                child: GestureDetector(
                  onTap: ()=>BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedOut()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.doorOpen,
                        color: Colors.white,
                        size: 20,
                        semanticLabel: 'Icon menu',
                      ),
                      SizedBox(width: 15.0),
                      Text("Esci", style: title_rev),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  MapEntry<String, Widget> _buildMenu(
      LinkMenu view, String route, BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final b = BlocProvider.of<BackdropBloc>(context);
    return new MapEntry(
        route,
        GestureDetector(
          onTap: () => b.dispatch(NavigateEvent(route,null)),
          child: currentViewRoute == route
              ? Column(
            children: <Widget>[
              SizedBox(height: 16.0),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Icon(
                          view.iconLink,
                          color: view.colorIcon,
                          size: view.sizeIcon,
                          semanticLabel: 'Icon menu',
                        ),
                        SizedBox(width: 15.0),
                        Container(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                view.textLink,
                                style: title_rev,
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: yellow,
                                      width: 2.0,
                                    )))
                        ),

                      ],
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
              ),
            ],
          )
              : Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  view.iconLink,
                  color: view.colorIcon,
                  size: view.sizeIcon,
                  semanticLabel: 'Icon menu',
                ),
                SizedBox(width: 15.0),
                Text(view.textLink, style: title_rev),
              ],
            ),
          ),
        ));
  }
}