/*
THIS IS THE MAIN PAGE OF THE OPERATOR
-l'appBar contiene menu a sinistra, titolo al centro, profilo a destra
-in alto c'è una riga di giorni della settimana selezionabili
-(R)al centro e in basso c'è una grglia oraria dove sono rappresentati gli eventi dell'operatore corrente del giorno selezionato in alto
-(o)al centro e in basso c'è una grglia oraria dove sono rappresentati i propri eventi del giorno selezionato in alto
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venturiautospurghi/bloc/events_bloc/events_bloc.dart';
import 'package:venturiautospurghi/plugin/table_calendar/table_calendar.dart';
import 'package:venturiautospurghi/bloc/backdrop_bloc/backdrop_bloc.dart';
import 'package:venturiautospurghi/utils/global_contants.dart' as global;
import 'package:venturiautospurghi/utils/global_methods.dart';
import 'package:venturiautospurghi/view/splash_screen.dart';
import '../utils/theme.dart';

class MonthlyCalendar extends StatefulWidget {
  final DateTime month;
  MonthlyCalendar(this.month, {Key key}) : super(key: key);

  @override
  _MonthlyCalendarState createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  DateTime _selectedMonth;
  AnimationController _animationController;
  CalendarController _calendarController;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.month!=null?widget.month:Utils.formatDate(DateTime.now(), "month");
    _events = Map();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

      //MAIN BUILEDER METHODS
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is Loaded) {
            //get data
            BlocProvider.of<EventsBloc>(context).dispatch(FilterEventsByMonth(_selectedMonth));
            ready = true;
          }else if(state is Filtered && ready){
            if (state.events.length > 0) _events[state.selectedDay] = state.events;
            return new Material(
              elevation: 12.0,
              borderRadius: new BorderRadius.only(
                  topLeft: new Radius.circular(16.0),
                  topRight: new Radius.circular(16.0)),
                child: Stack(children: <Widget>[
                  Positioned.fill( child:_buildTableCalendarWithBuilders(),),
                ],)
            );
          }
          return SplashScreen();
        }
    );
  }

        //--CALENDAR
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'it_IT',
      calendarController: _calendarController,
      events: _events,
      holidays: global.Constants().holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: {CalendarFormat.month: ''},
      initialSelectedDay: _selectedMonth,
      headerStyle: HeaderStyle(
        rightChevronIcon: Icon(null)
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: dark,
                      width: 3
                  )
                )
              ),
              child: Center(
                child:Text(
                  '${date.day}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333),fontSize: 18)
              ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
            decoration: BoxDecoration(
              color: grey_light,
              borderRadius: BorderRadius.circular(10.0),
          ),
            child: Center(child:Text(
              '${date.day}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333),fontSize: 18)
            ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          if (holidays.isNotEmpty && false) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      selectNext: (){},
      selectPrevious: (){},
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

      //METODI DI CALLBACK
  void _onDaySelected(DateTime day, List events) {
    BlocProvider.of<BackdropBloc>(context).dispatch(NavigateEvent(global.Constants.dailyCalendarRoute,day));
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    BlocProvider.of<EventsBloc>(context).dispatch(FilterEventsByMonth(Utils.formatDate(first,"month")));
  }

}