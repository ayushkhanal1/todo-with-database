import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  DialogBox({super.key, required this.textcontroller,required this.onCancel,required this.onSave});
  final TextEditingController textcontroller;
   VoidCallback onSave;
   VoidCallback onCancel;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 228, 240, 105),
        content: Container(
          height: 115,
          width: 300,
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                    /*border: OutlineInputBorder(),*/ hintText:
                        'ENTER NEW TASK'),
                controller: textcontroller,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed:onCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(
                    width: 110,
                  ),
                  ElevatedButton(
                    onPressed: onSave,
                    child: const Text('Save'),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
