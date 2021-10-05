import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddEvent extends StatelessWidget {
  AddEvent() : super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return (Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white),
        child: Form(
            child: Column(
          children: [
            TextFormField(
              controller: _eventNameController,
              validator: (value) {
                return (value!.isEmpty) ? 'El evento debe tener nombre' : null;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  filled: true,
                  hintText: "Nombre"),
            ),
            SizedBox(
              height: 10,
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
                  "Fecha y hora",
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
        ))));
  }
}
