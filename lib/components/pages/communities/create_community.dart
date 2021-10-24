import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:flutter/material.dart';

class CreateCommunity extends StatefulWidget {
  final Community community;
  final List<FileImage> images;
  final FileImage logo;

  const CreateCommunity(this.community, this.images, this.logo) : super();

  @override
  _CreateCommunityState createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  bool requestCompleted = false;
  bool imageCompleted = false;
  bool error = false;

  @override
  void initState() {
    super.initState();
    final communityService = CommunityService();
    communityService.post(widget.community).then((value) {
      if (value == false)
        setState(() {
          error = true;
        });

      setState(() {
        requestCompleted = true;
      });
    });
    for (FileImage img in widget.images) {
      communityService.sendImage(img).then((value) {
        if (!value) {
          setState(() {
            error = true;
          });
        }
        setState(() {
          imageCompleted = true;
        });
      });
    }
    communityService.sendImage(widget.logo).then((value) {
      if (!value) {
        setState(() {
          error = true;
        });
      }
      setState(() {
        imageCompleted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.check_rounded;
    String text = "Comunidad creado con éxito";
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
