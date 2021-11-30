import 'package:eventy_front/components/pages/my_events/event_view.dart';
import 'package:eventy_front/components/widgets/filled_button.dart';
import 'package:eventy_front/objects/survey.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AddSurvey extends StatefulWidget {
  final int eventId;
  const AddSurvey(this.eventId) : super();

  @override
  _AddSurveyState createState() => _AddSurveyState();
}

class _AddSurveyState extends State<AddSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _surveyNameController = TextEditingController();
  final TextEditingController _optionsController = TextEditingController();
  String startDateLabel = "Sin seleccionar";
  String finishDateLabel = "Sin seleccionar";
  DateTime startDate = DateTime.now().add(Duration(days: 1));
  DateTime finishDate = DateTime.now().add(Duration(days: 2));
  List<String> options = [];
  late Survey survey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crear encuesta"),
          automaticallyImplyLeading: true,
        ),
        body: (SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _surveyNameController,
                        validator: (value) {
                          return (value!.isEmpty)
                              ? 'La encuesta debe tener nombre'
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
                      Row(
                        children: [
                          Container(
                            width: 250,
                            child: TextFormField(
                              controller: _optionsController,
                              validator: (value) {
                                return (value!.isEmpty)
                                    ? 'No se puede dejar el campo en blanco'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  filled: true,
                                  hintText: "Opción"),
                            ),
                          ),
                          Spacer(),
                          FilledButton(
                              onPressed: () {
                                if (_optionsController.text.isNotEmpty) {
                                  setState(() {
                                    options.add(_optionsController.text);
                                  });
                                }
                              },
                              text: "Añadir")
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Duración", style: TextStyle(fontSize: 18)),
                      SizedBox(
                        height: 15,
                      ),
                      buildDatePickers("Fecha de inicio", true, context),
                      SizedBox(
                        height: 15,
                      ),
                      buildDatePickers("Fecha de final", false, context),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Lista de opciones", style: TextStyle(fontSize: 18)),
                      SizedBox(
                        height: 10,
                      ),
                      buildListOptions(options),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: FilledButton(
                            onPressed: () {
                              createSurvey(context);
                            },
                            text: "Crear"),
                      )
                    ],
                  ))),
        )));
  }

  Widget buildListOptions(List optionsList) {
    if (optionsList.isNotEmpty) {
      return Column(
        children: [
          ...optionsList.map((option) {
            return ListTile(
                title: Text(option),
                leading: IconButton(
                    onPressed: () {
                      setState(() {
                        options.remove(option);
                      });
                    },
                    icon: Icon(Icons.delete)));
          }),
        ],
      );
    } else {
      return Container(
          alignment: Alignment.center, child: Text("No hay opciones"));
    }
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

  bool validateFields(BuildContext context) {
    if (options.isEmpty) {
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
    return true;
  }

  void createSurvey(BuildContext context) async {
    if (_formKey.currentState!.validate() && validateFields(context)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment.topLeft,
                    width: 200,
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Crear encuesta",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.black87),
                        ),
                        TextButton.icon(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              survey = Survey(
                                '',
                                _surveyNameController.text,
                                0,
                                options,
                                false,
                                startDate.toIso8601String(),
                                finishDate.toIso8601String(),
                              );
                              EventService()
                                  .postSurvey(survey, widget.eventId.toString())
                                  .then((value) => Navigator.of(context).pop());
                            },
                            label: Text(
                              "Aceptar",
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton.icon(
                            icon: Icon(Icons.cancel, color: Colors.redAccent),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            label: Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    )));
          });
    }
  }
}