import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:group_radio_button/group_radio_button.dart';

class AddEvent extends StatefulWidget {
  const AddEvent() : super();

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _assistantsController = TextEditingController();
  String _visibilityValue = "Público";
  bool hasMaxAssistants = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear evento"),
        automaticallyImplyLeading: true,
      ),
      body: (SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(color: Colors.white),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                            style: BorderStyle.solid)),
                    child: Container(
                      height: 100,
                      child: Center(
                          child: Icon(Icons.photo_camera_rounded,
                              color: Theme.of(context).primaryColor)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                  SizedBox(
                    height: 20,
                  ),
                  buildVisibilityRadioGroup(context),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 180,
                    child: TextFormField(
                      maxLength: 10,
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.euro_rounded),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          filled: true,
                          hintText: "Precio"),
                    ),
                  ),
                  buildMaxAssistants(context),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity,
                              50), // double.infinity is the width and 30 is the height
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {},
                      icon: Icon(Icons.add_rounded),
                      label: Text("Publicar evento"))
                ],
              ))))),
    );
  }

  Widget buildMaxAssistants(BuildContext context) {
    return (Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Número máximo de asistentes",
              style: TextStyle(color: Colors.black54),
            ),
            Checkbox(
                value: hasMaxAssistants,
                onChanged: (value) {
                  setState(() {
                    hasMaxAssistants = value!;
                  });
                })
          ],
        ),
        Container(
          width: 180,
          child: TextFormField(
              enabled: hasMaxAssistants,
              maxLength: 10,
              controller: _assistantsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  filled: true,
                  hintText: "Asistentes")),
        )
      ],
    ));
  }

  Widget buildVisibilityRadioGroup(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Visibilidad del evento",
          style: TextStyle(color: Colors.black54),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            RadioButton(
                description: "Público",
                value: "Público",
                groupValue: _visibilityValue,
                onChanged: (value) {
                  setState(() {
                    _visibilityValue = value as String;
                  });
                }),
            RadioButton(
                description: "Privado",
                value: "Privado",
                groupValue: _visibilityValue,
                onChanged: (value) {
                  setState(() {
                    _visibilityValue = value as String;
                  });
                })
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
}
