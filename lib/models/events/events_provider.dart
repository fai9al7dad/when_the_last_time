import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:when_the_last_time/models/events/event_model.dart';
import 'package:when_the_last_time/models/events/events_repo.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:when_the_last_time/utils/bussines_logic.dart';

class EventsProvider extends ChangeNotifier {
  final eventRepo = EventsRepo();

  // create list of events
  List<Event> _events = [];

  // create getter for events
  List<Event> get events => _events;

  // get events
  Future<void> getEvents() async {
    _events = await eventRepo.getEvents();
    notifyListeners();
  }

  void addEvent(Event event) async {
    await eventRepo.insertEvent(event);
    _events = await eventRepo.getEvents();
    notifyListeners();
    playClickSF();
  }

  void removeEvent(Event event) async {
    await eventRepo.deleteEvent(event);
    _events = await eventRepo.getEvents();
    notifyListeners();
    playPopSF();
  }

  // restore event
  void restoreEvent(Event event) async {
    await eventRepo.restoreEvent(event);
    _events = await eventRepo.getEvents();
    notifyListeners();
  }

  void updateEvent(Event event) async {
    await eventRepo.updateEvent(event);
    _events = await eventRepo.getEvents();
    notifyListeners();
  }

  void addEventHistory(Event event) async {
    await eventRepo.addEventHistory(event);
    await eventRepo.updateEventDateToNow(event);
    _events = await eventRepo.getEvents();
    notifyListeners();
  }

  // delete event history
  void deleteEventHistory(EventRestoreHistory event) async {
    await eventRepo.deleteEventHistory(event);
    _events = await eventRepo.getEvents();
    notifyListeners();
  }

  Event getEvent(int index) {
    return _events[index];
  }
}
