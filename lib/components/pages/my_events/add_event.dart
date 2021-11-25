import 'dart:io';
import 'package:eventy_front/components/pages/my_events/create_event.dart';
import 'package:eventy_front/components/pages/my_events/create_survey.dart';
import 'package:eventy_front/components/pages/my_events/map_view.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:eventy_front/services/tags_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

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
  final TextEditingController _addressController = TextEditingController();

  List<String> tags = [];
  List<String> tagsEvent = [];
  ////////////////
  late List scores;
  late double averageScore;
  ///////////////////
  String _visibilityValue = "Público";
  bool hasMaxAssistants = false;

  String startDateLabel = "Sin seleccionar";
  String finishDateLabel = "Sin seleccionar";
  DateTime startDate = DateTime.now().add(Duration(days: 1));
  DateTime finishDate = DateTime.now().add(Duration(days: 2));

  LatLng? eventLocation;
  String hasLocation = "Sin seleccionar";
  IconData hasLocationIcon = Icons.place_rounded;

  List<ImageProvider> imageProviders = [];
  List<FileImage> imageFiles = [];
  ImagePicker picker = ImagePicker();
  FileImage? imageToSend;

  _imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      imageProviders.add(FileImage(File(image!.path)));
      imageFiles.add(FileImage(File(image.path)));
      imageToSend = FileImage(File(image.path));
    });
  }

  @override
  void initState() {
    super.initState();
    TagsService().get().then((value) => setState(() {
          print("Here");
          tags = value;
        }));
  }

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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            //
                            _imgFromGallery();
                          }, // handle your image tap here
                          child: Card(
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
                          )),
                      SizedBox(height: 10),
                      Container(
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 3,
                          children: [
                            ...imageProviders.map((e) => Column(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                            height: 65,
                                            width: 105,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: e,
                                                    fit: BoxFit.fitWidth)))),
                                    SizedBox(
                                      height: 30,
                                      child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              imageProviders.remove(e);
                                              imageFiles.remove(e);
                                            });
                                          },
                                          child: Text(
                                            "Eliminar",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                    )
                                  ],
                                ))
                          ],
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
                      buildDatePickers("Fecha de inicio", true, context),
                      SizedBox(
                        height: 20,
                      ),
                      buildDatePickers("Fecha de final", false, context),
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
                      Text(
                        "Tags",
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Wrap(
                        spacing: 5,
                        runSpacing: 3,
                        children: [
                          ...tags.map((tag) => FilterChip(
                                label: Text(tag),
                                backgroundColor: Color(0xFFF1F1F1),
                                selected: tagsEvent.contains(tag),
                                selectedColor: Colors.lightBlue[100],
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      tagsEvent.add(tag);
                                    } else {
                                      tagsEvent.remove(tag);
                                    }
                                  });
                                },
                              ))
                        ],
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              // double.infinity is the width and 30 is the height
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
/*                         if (imageToSend != null) {
                          EventService().sendImage(imageToSend!).then((value) {
                            String result =
                                value ? "Envío correcto" : "Fallo en el envío";
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(result)));
                          });
                        } */
                            createEvent(context);
                          },
                          icon: Icon(Icons.add_rounded),
                          label: Text("Publicar evento"))
                    ],
                  ))))),
    );
  }

  void showPlacePicker(BuildContext context) async {
    LatLng? result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MapPositionSelector()));
    if (result != null) {
      setState(() {
        eventLocation = result;
        hasLocation = "Seleccionada";
        hasLocationIcon = Icons.done_rounded;
      });
    }
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
              validator: (value) {
                if (hasMaxAssistants)
                  return (value!.isEmpty)
                      ? "Asistentes no debe estar vacío"
                      : null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  filled: true,
                  hintText: "Asistentes")),
        ),
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
              hasLocationIcon,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              hasLocation,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Spacer(),
            TextButton(
              child: Text(
                "Cambiar",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                showPlacePicker(context);
              },
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: TextFormField(
              controller: _addressController,
              validator: (value) {
                return (value!.isEmpty)
                    ? "El evento debe tener dirección"
                    : null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  filled: true,
                  hintText: "Dirección")),
        )
      ],
    );
  }

  Widget buildDatePickers(String title, bool isStart, BuildContext context) {
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
              (isStart) ? startDateLabel : finishDateLabel,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Spacer(),
            TextButton(
              child: Text(
                "Cambiar",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(Duration(days: 730)),
                    onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  print('confirm $date');
                  setState(() {
                    final DateFormat formatter = DateFormat('dd/MM/yyyy');
                    final String formatted = formatter.format(date);
                    if (isStart) {
                      startDate = date;
                      startDateLabel = formatted;
                    } else {
                      finishDate = date;
                      finishDateLabel = formatted;
                    }
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.es);
              },
            ),
          ],
        )
      ],
    );
  }

  Widget buildButtonSurveyDate() {
    return ElevatedButton.icon(
        onPressed: () {
          /*Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return CreateSurvey(id del evento);
            }));*/
        },
        icon: Icon(Icons.calendar_today_rounded),
        label: Text("Encuesta"));
  }

  bool validateFields(BuildContext context) {
    if (imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Debes seleccionar al menos una imagen")));
      return false;
    }
    if (startDate.isAfter(finishDate)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content:
              Text("La fecha de final no debe ser posterior a la de inicio")));
      return false;
    }
    if (startDate.isBefore(DateTime.now()) ||
        finishDate.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Las fechas no pueden ser anteriores a la actual")));
      return false;
    }
    if (eventLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Debes seleccionar una ubicación")));
      return false;
    }
    return true;
  }

  void createEvent(BuildContext context) async {
    if (_formKey.currentState!.validate() && validateFields(context)) {
      String userId =
          await MySharedPreferences.instance.getStringValue("userId");
      double precio = (_priceController.text.isEmpty)
          ? 0
          : double.parse(_priceController.text);
      final Event event = Event(
        -1,
        _descriptionController.text,
        startDate.toIso8601String(),
        finishDate.toIso8601String(),
        imageFiles.map((e) => basename(e.file.path)).toList(),
        eventLocation!.latitude,
        eventLocation!.longitude,
        (hasMaxAssistants) ? int.parse(_assistantsController.text) : -1,
        [userId],
        _eventNameController.text,
        userId,
        precio,
        (_visibilityValue == "Público") ? false : true,
        _summaryController.text,
        tagsEvent,
        ///////////////
        scores = List.empty(growable: true), // userId, puntuación
        averageScore = 0,
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return CreateEvent(event, imageFiles);
      }));
    }
  }
}
