library App.globals;
import 'package:venturiautospurghi/models/event_model.dart';

bool isLoggedIn = false;
bool isSupervisor = true;

class Constants {
  //Calendar related
  final Map<DateTime, List> holidays = {
    DateTime(2019, 1, 1): [new Event("New Year\'s Day", "", DateTime(2019, 1, 1),DateTime(2019, 1, 1),"","")],
    DateTime(2019, 1, 6): [new Event("Epiphany", "", DateTime(2019, 1, 6),DateTime(2019, 1, 6),"","")],
    DateTime(2019, 2, 14): [new Event("Valentine\'s Day", "", DateTime(2019, 2, 14),DateTime(2019, 2, 14),"","")],
    DateTime(2019, 4, 21): [new Event("Easter Sunday", "", DateTime(2019, 4, 21),DateTime(2019, 4, 21),"","")],
    DateTime(2019, 4, 22): [new Event("Easter Monday", "", DateTime(2019, 4, 22),DateTime(2019, 4, 22),"","")]
  };

  //Event related
  //TODO sarebbe bello averle su database queste categorie
  Map<String,int> category = {
    "Spurghi":0xFF0503FB,
    "Fogne":0xFF05F30B,
    "Tombini":0xFFC5032B,
  };

  // Flutter Routes
  static const String globalCalendarRoute = '/global_calendar';
  static const String dailyCalendarRoute = '/daily_calendar';
  static const String operatorListRoute = '/op_list';
  static const String eventViewRoute = '/event_creator';
  static const String eventCreatorRoute = '/event_creator';
  static const String profileRoute = '/profile';
  static const String resetCodeRoute = '/reset_code_page';
  static const  String logInRoute = '/log_in_page';
  static bool debug = false;
}