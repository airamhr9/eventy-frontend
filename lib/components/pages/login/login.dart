import 'package:eventy_front/components/pages/login/register.dart';
import 'package:eventy_front/components/root.dart';
import 'package:eventy_front/navigation/navigation.dart';
import 'package:eventy_front/objects/login_response.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage() : super();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Spacer(),
              Icon(
                Icons.calendar_today_rounded,
                size: 55,
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(left: 5),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Iniciar sesión",
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
                    validator: (value) {
                      return (value!.isEmpty)
                          ? "La contraseña no debe estar vacía"
                          : null;
                    },
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
                height: 10,
              ),
              Container(
                child: TextFormField(
                    validator: (value) {
                      return (value!.isEmpty)
                          ? "La contraseña no debe estar vacía"
                          : null;
                    },
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
                height: 15,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      // double.infinity is the width and 30 is the height
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      UserService()
                          .login(_usernameController.text,
                              _passwordController.text)
                          .then((value) {
                        if (value.success) {
                          MySharedPreferences.instance
                              .setStringValue("userId", value.id);
                          MySharedPreferences.instance
                              .setBooleanValue("isLoggedIn", true);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Root(
                                        selectedPage: EventsNavigation.NAV_HOME,
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value.error),
                            backgroundColor: Colors.red,
                          ));
                        }
                      });
                    }
                    /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Root(selectedPage: EventsNavigation.NAV_HOME))); */
                  },
                  child: Text("Iniciar sesión")),
              SizedBox(
                height: 15,
              ),
              buildRegisterText(),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegisterText() {
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 15.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(text: '¿No tienes cuenta? '),
          TextSpan(
              text: 'Registrarse',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                }),
        ],
      ),
    );
  }
}
