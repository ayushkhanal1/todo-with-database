import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  TodoTile(
      {super.key,
      required this.changed,
      required this.taskname,
      required this.taskstatus,
      required this.ondelete});
  final String taskname;
  final bool taskstatus;
  void Function(bool?)? changed;
  void Function(BuildContext) ondelete;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion:const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: ondelete,
              backgroundColor: Colors.red,
              icon: Icons.delete,
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Checkbox(value: taskstatus, onChanged: changed),
              Text(
                taskname,
                style: TextStyle(
                    fontSize: 16,
                    decoration: taskstatus
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.yellow),
        ),
      ),
    );
  }
}
