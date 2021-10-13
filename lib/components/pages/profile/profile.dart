import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile() : super();

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return (SingleChildScrollView(
        child: BuildProfile()

    ));
  }

  Container BuildProfile() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(color: Colors.white),
        child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
            Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                radius: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Usuario",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Mi estado bla bla bla bla bla",
                style: TextStyle(

                    color: Colors.black54),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Valencia, España",
                style: TextStyle(

                    color: Colors.black38),
              ),
             /* TextButton.icon(onPressed:
              (){}, icon:  Icon(
                  Icons.edit_rounded
              ), label: Text(
                  "Editar"
                  
              )),*/

              Divider(indent: 16),
            ]),
        Text(

          "Mis preferencias",
          style: TextStyle(
              color: Colors.black54),
        ),
        /*Wrap(
          children: List<Widget>.generate(
            options.length,
                (int idx) {
              return ChoiceChip(
                  label: Text(options[idx]),
                  selected: _value == idx,
                  onSelected: (bool selected) {
                    setState(() {
                      _value = selected ? idx : null;
                    });
                  });
            },
          ).toList(),
        );*/
        ]
    ));
  }
}
