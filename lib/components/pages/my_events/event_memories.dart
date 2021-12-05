import 'dart:io';

import 'package:eventy_front/components/pages/my_events/event_view.dart';
import 'package:eventy_front/components/pages/my_events/memory_card.dart';
import 'package:eventy_front/components/widgets/filled_button.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/memory.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class EventsMemories extends StatefulWidget {
  final Event event;
  const EventsMemories(this.event) : super();

  @override
  _EventsMemoriesState createState() => _EventsMemoriesState();
}

class _EventsMemoriesState extends State<EventsMemories> {
  List<Memory> memories = [];
  bool hasMemories = false;
  bool addMemory = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  int count = 0;

  ImagePicker picker = ImagePicker();
  ImageProvider _img = NetworkImage("");
  File _imgFile = File("");
  String imgMemory = "";

  @override
  initState() {
    _fetchMemories();
    super.initState();
  }

  _fetchMemories() async {
    EventService()
        .getEventMemories(widget.event.id.toString())
        .then((value) => setState(() {
              memories = value;
              hasMemories = true;
            }));
  }

  _imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _imgFile = File(image!.path);
      print(_imgFile.path);
      _img = FileImage(_imgFile);
      imgMemory = _imgFile.path.split('/').last;
      print(_imgFile.path.split('/').last);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Recuerdos",
              style: TextStyle(
                  fontFamily: 'Tiny', fontSize: 30, color: Colors.black),
            ),
            TextButton(
                child: Text(
                  "Añadir",
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
                onPressed: () {
                  if (count == 0) {
                    setState(() {
                      addMemory = true;
                      count = 1;
                    });
                  } else {
                    if (_formKey.currentState!.validate() &&
                        validateFields(context)) {
                      Memory mem = Memory(
                        _descriptionController.text,
                        imgMemory,
                      );
                      EventService()
                          .postMemory(widget.event.id.toString(), mem)
                          .then((value) {
                        setState(() {
                          addMemory = false;
                          count = 0;
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventView(widget.event)));
                      });
                      EventService().sendMemoryImage(FileImage(_imgFile));
                    }
                  }
                })
          ],
        ),
        SizedBox(
          height: 20,
        ),
        (hasMemories)
            ? (memories.length > 0)
                ? Container(
                    child: Column(children: [
                    ...memories.map((memory) {
                      return Column(
                        children: [
                          MemoriesCard(memory),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    })
                  ]))
                : Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("No hay recuerdos"),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
            : CircularProgressIndicator(),
        SizedBox(
          height: 30,
        ),
        buildAddMemory(),
        SizedBox(
          height: 20,
        ),
      ]),
    );
  }

  Widget buildAddMemory() {
    if (addMemory == true) {
      return Container(
          child: Form(
              key: _formKey,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        _imgFromGallery();
                      },
                      child: Container(
                          height: 140,
                          width: 140,
                          child: Card(
                            elevation: 0,
                            shape: CircleBorder(
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                    style: BorderStyle.solid)),
                            child: Container(
                                height: 100, child: Center(child: buildImg())),
                          ))),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 140,
                      width: 220,
                      child: TextFormField(
                        minLines: 8,
                        maxLines: 20,
                        controller: _descriptionController,
                        validator: (value) {
                          return (value!.isEmpty)
                              ? 'El recuerdo debe tener descripción'
                              : null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            filled: false,
                            hintText: "Escribe aquí..."),
                      )),
                ],
              )));
    } else {
      return SizedBox(
        height: 1,
      );
    }
  }

  Widget buildImg() {
    if (_imgFile.path.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: _img,
        radius: 80,
      );
    } else {
      return Center(
          child: Icon(Icons.photo_camera_rounded,
              color: Theme.of(context).primaryColor));
    }
  }

  bool validateFields(BuildContext context) {
    if (_img.toString() == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Debes seleccionar al menos una imagen")));
      return false;
    }
    return true;
  }
}
