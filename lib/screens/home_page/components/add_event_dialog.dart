import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:when_the_last_time/models/events/event_model.dart';
import 'package:when_the_last_time/models/events/events_provider.dart';
import 'package:when_the_last_time/utils/bussines_logic.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({Key? key}) : super(key: key);

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateController.text = DateTime.now().toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('إضافة حدث'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'الرجاء إدخال الاسم';
                  }
                  if (value.replaceAll(' ', '') == "") {
                    return 'الرجاء إدخال الاسم';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'اسم الحدث *',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'الوصف',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // create button that opens date picker
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
              Navigator.of(context).pop();
            },
            child: const Text('الغاء'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Provider.of<EventsProvider>(context, listen: false).addEvent(
                  Event(
                    name: _nameController.text,
                    description: _descriptionController.text,
                    date: DateTime.parse(_dateController.text),
                    location: _locationController.text,
                    image: _imageController.text,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
