import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddEvent extends StatelessWidget {
  AddEvent() : super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return (SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(color: Colors.white),
            child: Form(
                child: Column(
              children: [
                TextFormField(
                  controller: _eventNameController,
                  validator: (value) {
                    return (value!.isEmpty)
                        ? 'El evento debe tener nombre'
                        : null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintText: "Nombre"),
                ),
                SizedBox(
                  height: 20,
                ),
                buildDatePickers("Fecha de inicio", context),
                SizedBox(
                  height: 20,
                ),
                buildDatePickers("Fecha de final", context),
                SizedBox(
                  height: 20,
                ),
                buildMapPicker(context),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  minLines: 1,
                  controller: _summaryController,
                  validator: (value) {
                    return (value!.isEmpty)
                        ? 'El evento debe tener resumen'
                        : null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintText: "Resumen"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  minLines: 8,
                  maxLines: 20,
                  controller: _descriptionController,
                  validator: (value) {
                    return (value!.isEmpty)
                        ? 'El evento debe tener descripcion'
                        : null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintText: "Descripcion"),
                ),
              ],
            )))));
  }

  Widget buildDatePickers(String title, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.black54),
        ),
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Sin seleccionar",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Spacer(),
            TextButton(
              child: Text(
                "Cambiar",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(Duration(days: 730)),
                    onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  print('confirm $date');
                }, currentTime: DateTime.now(), locale: LocaleType.es);
              },
            ),
          ],
        )
      ],
    );
  }

  Widget buildMapPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ubicación",
          style: TextStyle(color: Colors.black54),
        ),
        Row(
          children: [
            Icon(
              Icons.place_rounded,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Sin seleccionar",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Spacer(),
            TextButton(
              child: Text(
                "Cambiar",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }
}
