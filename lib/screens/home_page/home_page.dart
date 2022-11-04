import 'package:flutter/material.dart';

import 'package:when_the_last_time/screens/home_page/components/add_event_dialog.dart';
import 'package:when_the_last_time/screens/home_page/components/events_list.dart';

class HomePage extends StatelessWidget {
  static String routeName = "/";
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: const EventsList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            // open dialog that contains form to add event
            showDialog(
                context: context,
                builder: (context) {
                  return const AddEventDialog();
                });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
