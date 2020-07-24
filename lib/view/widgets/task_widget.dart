import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

abstract class TaskWidget extends StatelessWidget {}

class SimpleTaskWidget extends TaskWidget {
  final String task, description;
  final Color color;

  SimpleTaskWidget({@required this.task, @required this.description, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          color: color,
          width: double.infinity,
          child: Row(
            children: [
              Spacer(
                flex: 1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task,
                  ),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Spacer(
                flex: 27,
              ),
              Checkbox(
                value: false,
                onChanged: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
