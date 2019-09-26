var calendar;
var db;
var categories;
var loggedId = "PCsJ86Gtiww4tmjbttu4";
var dart;
$(function() { // document ready
// Your web app's Firebase configuration
    var firebaseConfig = {
        apiKey: "AIzaSyD5sZzeqqH_wje72BWe3zoOR136YEh186k",
        authDomain: "com-l2pt-venturiautospurghi.firebaseapp.com",
        databaseURL: "https://com-l2pt-venturiautospurghi.firebaseio.com",
        projectId: "com-l2pt-venturiautospurghi",
        storageBucket: "com-l2pt-venturiautospurghi.appspot.com",
        messagingSenderId: "964614131015",
        appId: "1:964614131015:web:8a10af66f5b15bad589062"
    };
    // Initialize Firebase
    firebase.initializeApp(firebaseConfig);
    db=firebase.firestore();
    initCategories();

    /* initialize the calendar
    -----------------------------------------------------------------*/
    //this will be done after login

//              $('#calendar').fullCalendar( 'addResource',        { id: 'g', title: 'Matto', eventColor: 'orange' },);
//              $('#calendar').fullCalendar('today');

    $(document).on('click',".fc-resource-postfix",function(){
        var id = $(this).closest('tr').data("resource-id")
        calendar.removeResource(id);
        removeResource(id)
    });


  });

function initCalendar(){
     $('#calendar').fullCalendar({
        schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
        now: formatDate(new Date()),
        editable: true, // enable draggable events
        droppable: true, // this allows things to be dropped onto the calendar
        aspectRatio: 2,
        scrollTime: '00:00', // undo default 6am scrollTime
        header: {
                left: '',
                center: '',
                right: ''
              },
        defaultView: 'timelineDay',
        resourceLabelText: 'Tutti gli operatori',
        eventDataTransform: mapEventObj,
        resources: readResources,
        refetchResourcesOnNavigate: true,
        events: readEvents,
        drop: function(date, jsEvent, ui, resourceId) {
            console.log('drop', date.format(), resourceId);

            // is the "remove after drop" checkbox checked?
            if ($('#drop-remove').is(':checked')) {
              // if so, remove the element from the "Draggable Events" list
              $(this).remove();
            }
        },
        eventReceive: function(event) { // called when a proper external event is dropped
            console.log('eventReceive', event);
        },
        eventDrop: function(event) { // called when an event (already on the calendar) is moved
            console.log('eventDrop', event);
            dartCallback("stampa da js");
        },
        eventClick: function(calEvent, jsEvent, view) {//tell to dart to open the modal
            dart.showDialogWindow("event",calEvent)
        }
        });
        calendar = $('#calendar').fullCalendar('getCalendar');
}

function initCategories(){
    var docRef = db.collection("Costanti").doc("Categorie");
    docRef.get().then(function(doc) {
        if (doc.exists) {
            categories = doc.data();
            categories['default'] = '#fda90a';
        } else {
            console.log("No categories!");
        }
    }).catch(function(error) {
        console.log("Error getting categories:", error);
    });
}

function readResources(callback){
    var docRef = db.collection("Utenti").doc(loggedId);
    docRef.get().then(function(doc) {
        if (doc.exists) {
            var arr = doc.data().OperatoriWeb
            var res = [];
            for( var i = 0; i < arr.length; i++){
               res.push(arr[i]);
            }
            callback(res);
        } else {
            console.log("No web operator!");
        }
    }).catch(function(error) {
        console.log("Error getting user", error);
    });
}
function readEvents(start, end, timezone, callback){
   //var date = calendar.getDate().format();
   var docRef = db.collection("Eventi").where("DataInizio","<=",firebase.firestore.Timestamp.fromDate(new Date()))  ; //TODO ADD QUERY FOR RESOURCES ID
   var evs = [];
   docRef.get().then(function(querySnapshot) {
       querySnapshot.forEach(function(doc) {
           var e = doc.data();
           e.id= doc.id;
           evs.push(e)
       });
       callback(evs);
   }).catch(function(error) {
       console.log("Error getting Events:", error);
       callback(evs);
   });
}
function removeResource(res){
    var docRef = db.collection("Utenti").doc(loggedId);
    docRef.get().then(function(doc) {
        if (doc.exists){
           var arr = doc.data().OperatoriWeb;
           for( var i = 0; i < arr.length; i++){
              if (arr[i].id === res) {
                arr.splice(i, 1);
              }
           }
           db.collection("Utenti").doc(loggedId).update({OperatoriWeb:arr})
        } else {
           console.log("No user found on the db table!");
        }
    }).catch(function(error) {
        console.log("Error getting user:", error);
    });
}

function mapEventObj(eventData){
    if(eventData!=null){
        var e = eventData;
        e.resourceId = e.Operatore;
        e.resourceIds = e.subop;
        e.title = e.Titolo;
        e.url = e.Categoria;
        e.color = getColor(e.Categoria);
        e.start = new Date(e.DataInizio.seconds*1000).toISOString()
        e.end = new Date(e.DataFine.seconds*1000).toISOString()
        return e;
    }
}

/*-------------------------------------------------------------------*/
                        /*--DB--*/
function login(email){
    var docRef = db.collection("Utenti").where("Email","==",email);
    docRef.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(doc) {
            loggedId = doc.id;
            initCalendar();
            dart.updateDateCalendar();
            return;
        });
    }).catch(function(error) {
        console.log("Error getting user:", error);
    });
}





/*-------------------------------------------------------------------*/
                        /*--UTILITIES--*/
function getColor(arg){
    return (arg != null && categories[arg] != null)?categories[arg]:categories['default'];
}

function formatDate(date) {
      var day = date.getDate();
      var monthIndex = date.getMonth()+1;
      var year = date.getFullYear();

      return year + '-' + ((monthIndex/10<1)?0+''+monthIndex:monthIndex) + '-' + ((day/10<1)?0+''+day:day);
}
function initJs2Dart(callback){
    dart=callback;
}