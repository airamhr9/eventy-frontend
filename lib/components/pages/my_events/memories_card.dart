import 'package:eventy_front/objects/memorie.dart';
import 'package:flutter/material.dart';

class MemoriesCard extends StatelessWidget {
  final Memorie memorie;
  const MemoriesCard(this.memorie) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(memorie.image),
            backgroundColor: Colors.black,
            radius: 60,
          ),
          VerticalDivider(
            thickness: 1,
            color: Colors.black,
          ),
          Text(memorie.description),
        ],
      ),
    );
  }
}