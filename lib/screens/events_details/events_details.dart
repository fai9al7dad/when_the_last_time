import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:when_the_last_time/components/animated_list_view_wrapper.dart';

import 'package:when_the_last_time/components/custom_app_bar.dart';
import 'package:when_the_last_time/models/events/event_model.dart';
import 'package:when_the_last_time/models/events/events_repo.dart';
import 'package:when_the_last_time/utils/bussines_logic.dart';

class EventsDetails extends StatelessWidget {
  final Event? event;
  static String routeName = '/events-details';
  const EventsDetails({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "تاريخ ${event?.name} "),
        body: EventDetailsList(event: event));
  }
}

class EventDetailsList extends StatefulWidget {
  final Event? event;
  const EventDetailsList({super.key, required this.event});

  @override
  State<EventDetailsList> createState() => _EventDetailsListState();
}

class _EventDetailsListState extends State<EventDetailsList> {
  bool isLoading = true;
  List<EventRestoreHistory> _eventRestoreHistory = [];
  @override
  void initState() {
    super.initState();
    fetchEventsHistory();
  }

  void fetchEventsHistory() async {
    setState(() {
      isLoading = true;
    });
    final eventRepo = EventsRepo();
    final events = await eventRepo.getEventHistory(widget.event!);
    setState(() {
      _eventRestoreHistory = events;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Directionality(
        textDirection: TextDirection.rtl,
        child: _eventRestoreHistory.isEmpty
            ? const Center(
                child: Text("لا يوجد احداث"),
              )
            : AnimatedListViewWrapper(
                itemCount: _eventRestoreHistory.length,
                child: (index) => ListTile(
                  title: Text(timeAgo(_eventRestoreHistory[index].date)),
                  // trailing delete icon
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final eventRepo = EventsRepo();
                      await eventRepo
                          .deleteEventHistory(_eventRestoreHistory[index]);
                      setState(() {
                        _eventRestoreHistory.removeAt(index);
                      });
                    },
                  ),
                ),
              ));
  }
}
