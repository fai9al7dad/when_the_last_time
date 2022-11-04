import 'package:flutter/material.dart';

import 'package:when_the_last_time/models/events/event_model.dart';
import 'package:when_the_last_time/screens/events_details/events_details.dart';
import 'package:when_the_last_time/utils/bussines_logic.dart';

class EventTile extends StatelessWidget {
  final Event event;
  const EventTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: (() => {
              // show event details
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventsDetails(
                            event: event,
                          )))
            }),
        title: Text(event.name),
        subtitle: Text(event.description ?? " "),
        trailing: Text(
          timeAgo(event.date),
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ));
  }
}
