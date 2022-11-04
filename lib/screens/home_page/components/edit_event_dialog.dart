import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:when_the_last_time/models/events/event_model.dart';
import 'package:when_the_last_time/models/events/events_provider.dart';
import 'package:when_the_last_time/utils/bussines_logic.dart';

class EditEventDialog extends StatefulWidget {
  final Event event;
  const EditEventDialog({Key? key, required this.event}) : super(key: key);

  @override
  State<EditEventDialog> createState() => _EditEventDialogState();
}

class _EditEventDialogState extends State<EditEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  @override
  void initState() {
    _nameController.text = widget.event.name;
    _descriptionController.text = widget.event.description ?? "";
    _dateController.text = widget.event.date.toString();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('تعديل الحدث'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'الوصف',
                ),
              ),

              // date field should show a date picker

              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                      context: context,

                      // locale: const Locale('ar'),
                      initialDate: DateTime.parse(_dateController.text),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now());
                  if (date != null) {
                    _dateController.text = date.toString();
                  }
                  setState(() {});
                },
                child: Text(
                    "تاريخ الحدث:  ${timeAgo(DateTime.parse(_dateController.text))}"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء')),
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final eventsProvider =
                      Provider.of<EventsProvider>(context, listen: false);
                  eventsProvider.updateEvent(Event(
                      id: widget.event.id,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      date: DateTime.parse(_dateController.text)));
                  Navigator.pop(context);
                }
              },
              child: const Text('تعديل'))
        ],
      ),
    );
  }
}
