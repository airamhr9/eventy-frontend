import 'package:eventy_front/objects/memory.dart';
import 'package:flutter/material.dart';

class MemoriesCard extends StatelessWidget {
  final Memory memory;
  const MemoriesCard(this.memory) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(memory.image),
                  backgroundColor: Colors.black,
                  radius: 60,
                ),
                SizedBox(
                  width: 25,
                ),
                Text(memory.description),
              ],
            ),
          ],
        ));
  }
}
