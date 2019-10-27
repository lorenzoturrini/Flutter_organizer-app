import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:venturiautospurghi/models/event.dart';
import 'package:venturiautospurghi/models/user.dart';
import 'package:venturiautospurghi/repository/events_repository.dart';
import 'package:venturiautospurghi/repository/operators_repository.dart';

part 'operators_event.dart';

part 'operators_state.dart';

class OperatorsBloc extends Bloc<OperatorsEvent, OperatorsState> {

  final OperatorsRepository _operatorsRepository = OperatorsRepository();
  final EventsRepository _eventsRepository;
  StreamSubscription _eventsSubscription;
  List<Event> _events = [];
  List<Account> operators = [];
  String _stringQuery = null;
  DateTime _dateQuery = null;

  OperatorsBloc({@required EventsRepository eventsRepository})
      : assert(eventsRepository != null),
        _eventsRepository = eventsRepository;


  @override
  OperatorsState get initialState => NotLoaded();

  @override
  Stream<OperatorsState> mapEventToState(OperatorsEvent event) async* {
    if (event is LoadOperators) {
      yield* _initState(event);
    } else if (event is ApplyOperatorFilters) {
      yield* _mapLoadOperatorsFilteredToState(event);
    } else if (event is ApplyOperatorFilterString) {
      yield* _mapLoadOperatorsFilteredByStringToState(event);
    } else if (event is ApplyOperatorFilterDate) {
      yield* _mapLoadOperatorsFilteredByDateToState(event);
    } else if (event is AddOperator) {
      yield* _mapAddOperatorToState(event);
    } else if (event is EventsUpdated) {
      yield* _mapOperatorsUpdateToState(event);
    } else if (event is Done) {
      yield* _mapDoneToState(event);
    }
  }

  Stream<OperatorsState> _initState(LoadOperators event) async* {
    //use it as initializer
    //yield NotLoaded(); almost useless
    _eventsSubscription?.cancel();
    //subscribe and do dispatch of interested events
    _eventsSubscription = event.subscription().listen((events) {
      dispatch(
        EventsUpdated(events), //crea l'evento
      );
    });
    operators = await _operatorsRepository.getOperators();
    //data ready to be fetched
  }

  Stream<OperatorsState> _mapLoadOperatorsFilteredToState(ApplyOperatorFilters event) async* {
    //if both null it's a refresh
    if(!(event.stringFilter == null && event.dateFilter == null)){
      _stringQuery = event.stringFilter;
      _dateQuery = event.dateFilter;
    }
    filterAndDispatch();
  }

  Stream<OperatorsState> _mapLoadOperatorsFilteredByStringToState(ApplyOperatorFilterString event) async* {
    _stringQuery = event.stringFilter;
    filterAndDispatch();
  }

  Stream<OperatorsState> _mapLoadOperatorsFilteredByDateToState(ApplyOperatorFilterDate event) async* {
    _dateQuery = event.dateFilter;
    filterAndDispatch();
  }

  void filterAndDispatch(){
    List<Account> filteredOperators = operators;
    //filter them and return the operators
    if(_dateQuery!=null){
      _events.forEach((event) {
        if (event.isBetweenDate(_dateQuery, _dateQuery)) {
          event.idOperators.forEach((idOperator) {
            bool checkDelete = false;
            for (int i = 0; i < filteredOperators.length && !checkDelete; i++) {
              if (filteredOperators.elementAt(i).id == idOperator) {
                checkDelete = true;
                filteredOperators.removeAt(i);
              }
            }
          });
        }
      });
    }
    if(_stringQuery!=null && _stringQuery!=""){
      for (int i = 0; i < filteredOperators.length; i++) {
        if(!filteredOperators.elementAt(i).name.contains(_stringQuery) && !filteredOperators.elementAt(i).surname.contains(_stringQuery))
          filteredOperators.removeAt(i);
        }
    }
    dispatch(Done(filteredOperators));
  }

  Stream<OperatorsState> _mapAddOperatorToState(AddOperator event) async* {
    _operatorsRepository.addOperator(event.user);
  }

  Stream<OperatorsState> _mapOperatorsUpdateToState(EventsUpdated event) async* {
    _events = event.events;
    yield Loaded();
  }

  Stream<OperatorsState> _mapDoneToState(Done event) async* {
    yield Filtered(event.operators);  //cambia lo stato
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    super.dispose();
  }


}
