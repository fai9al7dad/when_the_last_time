import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:when_the_last_time/components/animated_list_view_wrapper.dart';
import 'package:when_the_last_time/components/event_tile.dart';
import 'package:when_the_last_time/models/events/events_provider.dart';
import 'package:when_the_last_time/screens/home_page/components/edit_event_dialog.dart';

class EventsList extends StatefulWidget {
  const EventsList({super.key});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  late bool isLoading;
  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  void fetchEvents() async {
    // call get events from events provider
    setState(() {
      isLoading = true;
    });
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    await eventsProvider.getEvents();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Consumer<EventsProvider>(builder: (context, eventsProvider, child) {
      return CustomScrollView(slivers: [
        SliverAppBar.large(
          title: const Text('متى آخر مرة ؟'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          stretch: true,

          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'متى آخر مرة ؟',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            stretchModes: const <StretchMode>[StretchMode.zoomBackground],
            background: Image.asset(
              fit: BoxFit.cover,
              "assets/images/appbar/wolfgang-hasselmann-pVr6wvUneMk-unsplash.jpg",
              color: Color.fromARGB(20, 0, 0, 0),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          // actions display soft deleted events when clicked
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/deleted-events');
                },
                tooltip: "الأحداث المؤرشفة",
                icon: const Icon(Icons.archive)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                tooltip: "الإعدادات",
                icon: const Icon(Icons.settings)),
          ],
        ),
        // SliverToBoxAdapter(
        //   child: Container(height: 700, color: Colors.black),
        // ),
        eventsProvider.events.isEmpty
            ? SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      kBottomNavigationBarHeight,
                  child: const Center(
                    child: Text('لا يوجد أحداث حاليا'),
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildListDelegate([
                  AnimatedListViewWrapper(
                    itemCount: eventsProvider.events.length,
                    child: (index) {
                      return Slidable(
                          key: Key(eventsProvider.events[index].id.toString()),
                          startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                // update event
                                SlidableAction(
                                  onPressed: (context) => {
                                    eventsProvider.addEventHistory(
                                        eventsProvider.events[index])
                                  },
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.update,
                                  label: 'تحديث',
                                ),
                              ]),
                          endActionPane: ActionPane(
                              dismissible: DismissiblePane(
                                onDismissed: () => {
                                  eventsProvider
                                      .removeEvent(eventsProvider.events[index])
                                },
                              ),
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => {
                                    // show edit event dialog
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return EditEventDialog(
                                              event:
                                                  eventsProvider.events[index]);
                                        })
                                  },
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.update,
                                  label: 'تعديل',
                                ),
                                SlidableAction(
                                  onPressed: (context) => {
                                    eventsProvider.removeEvent(
                                        eventsProvider.events[index])
                                  },
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  icon: Icons.archive,
                                  label: 'أرشفة',
                                ),
                              ]),
                          child: EventTile(
                            event: eventsProvider.events[index],
                          ));
                    },
                  )
                ]),
              ),
        // SliverToBoxAdapter(child: Expanded(child: EventsList()))
      ]);
    });
  }
}

// edit event dialog
