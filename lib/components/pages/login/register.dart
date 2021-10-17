import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage() : super();

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String dateSelected = "Sin seleccionar";
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        automaticallyImplyLeading: true,
        title: Text(
          "Volver a iniciar sesión",
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Spacer(),
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(left: 5),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Registro",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 3,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_rounded),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintText: "Nombre de usuario")),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail_rounded),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintText: "Correo electrónico")),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextFormField(
                  controller: _passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password_rounded),
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        icon: Icon(Icons.visibility_rounded),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintText: "Contraseña")),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: hideConfirmPassword,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password_rounded),
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        icon: Icon(Icons.visibility_rounded),
                        onPressed: () {
                          setState(() {
                            hideConfirmPassword = !hideConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintText: "Confirmar contraseña")),
            ),
            SizedBox(
              height: 20,
            ),
            buildDatePicker(context),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    // double.infinity is the width and 30 is the height
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {},
                child: Text("Registrarse")),
            SizedBox(
              height: 15,
            ),
            Spacer()
          ],
        ),
      ),
    );
  }

  Widget buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Fecha de nacimiento",
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
              dateSelected,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Spacer(),
            TextButton(
              child: Text(
                "Cambiar",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1900),
                    maxTime: DateTime.now(), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  setState(() {
                    final DateFormat formatter = DateFormat('dd/MM/yyyy');
                    final String formatted = formatter.format(date);
                    dateSelected = formatted;
                  });
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
