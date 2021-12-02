import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:eventy_front/objects/event.dart';

class CreateEvent extends StatefulWidget {
  final Event event;
  final List<FileImage> images;

  const CreateEvent(this.event, this.images) : super();

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  bool requestCompleted = false;
  bool imageCompleted = false;
  bool error = false;

  @override
  void initState() {
    super.initState();
    final eventService = EventService();
    eventService.postEvent(widget.event).then((value) {
      if (value == false)
        setState(() {
          error = true;
        });

      setState(() {
        requestCompleted = true;
      });
    });
    for (var image in widget.images) {
      eventService.sendImage(image).then((value) {
        if (!value) {
          setState(() {
            error = true;
          });
        }
        setState(() {
          if (image == widget.images.last) {
            imageCompleted = true;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = (error) ? Icons.error_rounded : Icons.check_rounded;
    String text = (error) ? "Error al crear evento" : "Evento creado con éxito";
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: (!requestCompleted || !imageCompleted)
              ? CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 60),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      text,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Volver",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
        ),
      ),
    );
  }
}
