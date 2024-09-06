import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/statemodel.dart';
import 'package:todo_app/taskmodel/taskmodel.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        backgroundColor: primary,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 15,
              child: Icon(
                Icons.check,
                color: Colors.blue,
                size: 22,
              ),
            ),
            SizedBox(width: 20),
            Text(
              "To Do List",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ],
        ),
      ),
      body: Consumer<TaskViewModel>(builder: (context, taskprovider, _) {
        return ListView.separated(
            itemBuilder: (context, index) {
              final task = taskprovider.tasks[index];
              return Listitems(
                task: task,
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: primary,
                height: 1,
                thickness: 1,
              );
            },
            itemCount: taskprovider.tasks.length);
      }),
      floatingActionButton: const CustomButton(),
    );
  }
}

class Listitems extends StatelessWidget {
  const Listitems({
    super.key,
    required this.task,
  });
  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 0),
      title: Text(
        task.taskName,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "${task.date},${task.time}",
        style: TextStyle(color: textBlue),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: primary,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return NewDialog();
          },
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0), // Ensure circular shape
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 45,
      ),
    );
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double sh = MediaQuery.sizeOf(context).height;
    double sw = MediaQuery.sizeOf(context).width;
    final taskProvider = Provider.of<TaskViewModel>(context, listen: false);

    return Dialog(
      backgroundColor: secondary,
      child: SizedBox(
        height: sh * 0.6,
        width: sw * 0.8,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Create New Task',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "What has to be done ?",
                style: TextStyle(
                  color: textBlue,
                ),
              ),
              NewTextField(
                hint: 'Enter a Task',
                onChanged: (value) {
                  taskProvider.setTaskName(value);
                },
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Due Date",
                style: TextStyle(
                  color: textBlue,
                ),
              ),
              NewTextField(
                hint: 'Pick a Date',
                controller: taskProvider.dateCont,
                readOnly: true,
                icon: Icons.calendar_month,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2034),
                  );
                  taskProvider.setDate(date);
                },
              ),
              const SizedBox(height: 10),
              NewTextField(
                hint: 'Pick a Time',
                controller: taskProvider.timeCont,
                readOnly: true,
                icon: Icons.timer,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  taskProvider.settime(time);
                },
              ),
              SizedBox(
                height: 60,
              ),
              Center(
                  child: ElevatedButton(
                      //  style: ElevatedButton.styleFrom(background),
                      onPressed: () async {
                        await taskProvider.addTask();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "CREATE",
                        style: TextStyle(color: primary),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class NewTextField extends StatelessWidget {
  const NewTextField({
    super.key,
    required this.hint,
    this.icon,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.controller,
  });
  final String hint;
  final IconData? icon;
  final void Function()? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: onTap,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
