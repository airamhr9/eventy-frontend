import 'package:eventy_front/objects/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class CreateSurvey extends StatefulWidget {
  const CreateSurvey() : super();

  @override
  _CreateSurveyState createState() => _CreateSurveyState();
}

class _CreateSurveyState extends State<CreateSurvey> {
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
              decoration: BoxDecoration(color: Colors.white),
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
                          TextFormField(
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
                                hintText: ""),
                          ),
                          Spacer(),
                          ElevatedButton(
                              onPressed: () {
                                if (_optionsController.text.isNotEmpty) {
                                  setState(() {
                                    options.add(_optionsController.text);
                                  });
                                }
                              },
                              child: Text("Añadir opción"))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Duración"),
                      SizedBox(
                        height: 5,
                      ),
                      buildDatePickers("Fecha de inicio", true, context),
                      SizedBox(
                        height: 15,
                      ),
                      buildDatePickers("Fecha de final", false, context),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Lista de opciones"),
                      SizedBox(
                        height: 5,
                      ),
                      ListView.separated(
                          itemBuilder: (context, index) {
                            if (options.isNotEmpty) {
                              return ListTile(
                                title: Text(options[index]),
                                leading: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        options.remove(options[index]);
                                      });
                                    },
                                    icon: Icon(Icons.delete)),
                              );
                            } else {
                              return Text("No hay opciones");
                            }
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: options.length),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            createSurvey(context);
                          },
                          child: Text("Crear encuesta"))
                    ],
                  ))))),
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

  void createSurvey(BuildContext context) {
    if (_formKey.currentState!.validate() && validateFields(context)) {
      survey = Survey(
        '',
        _surveyNameController.text,
        0,
        options,
        false,
        startDate.toIso8601String(),
        finishDate.toIso8601String(),
      );
    }
  }
}
