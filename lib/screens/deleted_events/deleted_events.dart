import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:when_the_last_time/components/animated_list_view_wrapper.dart';
import 'package:when_the_last_time/components/custom_app_bar.dart';
import 'package:when_the_last_time/components/event_tile.dart';
import 'package:when_the_last_time/models/events/event_model.dart';
import 'package:when_the_last_time/models/events/events_provider.dart';
import 'package:when_the_last_time/models/events/events_repo.dart';

class DeletedEvents extends StatelessWidget {
  static String routeName = "/deleted-events";
  const DeletedEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(title: "المؤرشفة"), body: DeletedEventsList());
  }
}

class DeletedEventsList extends StatefulWidget {
  const DeletedEventsList({super.key});

  @override
  State<DeletedEventsList> createState() => _DeletedEventsListState();
}

class _DeletedEventsListState extends State<DeletedEventsList> {
  final eventsRepo = EventsRepo();
  List<Event> events = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchDeletedEvents();
  }

  // fetch deleted events from repo
  void fetchDeletedEvents() async {
    // call get events from events provider
    setState(() {
      isLoading = true;
    });

    var deletedEvents = await eventsRepo.getDeletedEvents();

    setState(() {
      events = deletedEvents;
      isLoading = false;
    });
  }

  void restoreEvent(Event event) async {
    // call restore event from events provider
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    eventsProvider.restoreEvent(event);
    fetchDeletedEvents();
  }

  void deleteEvent(Event event) async {
    await eventsRepo.hardDeleteEvent(event);
    fetchDeletedEvents();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return events.isEmpty
        ? const Center(child: Text("لا يوجد أحداث محذوفة"))
        : Directionality(
            textDirection: TextDirection.rtl,
            child: AnimatedListViewWrapper(
              itemCount: events.length,
              child: (index) => Slidable(
                key: Key(events[index].id.toString()),
                startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    dismissible: DismissiblePane(
                      onDismissed: () => restoreEvent(events[index]),
                    ),
                    children: [
                      SlidableAction(
                        onPressed: (context) => restoreEvent(events[index]),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.restore_from_trash,
                        label: 'استعادة',
                      ),
                    ]),
                endActionPane: ActionPane(
                    dismissible: DismissiblePane(
                      onDismissed: () => deleteEvent(events[index]),
                    ),
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => deleteEvent(events[index]),
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'حذف',
                      ),
                    ]),
                child: EventTile(
                  event: events[index],
                ),
              ),
            ),
          );
  }
}
