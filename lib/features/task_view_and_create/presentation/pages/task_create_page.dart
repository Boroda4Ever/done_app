import 'package:done/core/init/lang/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/init/data_service/data_service.dart';
import '../../../../core/init/navigation/navigation_service.dart';
import '../../data/models/hive_task_model.dart';

class TaskCreatePage extends StatefulWidget {
  TaskModel? task;

  TaskCreatePage({super.key});
  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final TextEditingController _textController = TextEditingController();
  bool isFirstCall = true;
  String _selectedImportance = 'usual';
  String _taskText = '';
  DateTime? _dedline;
  bool _existDeadline = false;
  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _dedline) {
      setState(() {
        _dedline = picked;
      });
    }
    return picked;
  }

  _deleteDeadline(BuildContext context) {
    setState(() {
      _existDeadline = false;
      _dedline = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstCall) {
      RouteSettings? settings = ModalRoute.of(context)?.settings;
      if (settings!.arguments != null) {
        widget.task = settings.arguments as TaskModel;
      }
      if (widget.task != null) {
        _selectedImportance = widget.task!.importance;
        _taskText = widget.task!.text;
        _textController.text = _taskText;
        if (widget.task?.deadline != null) {
          _dedline = widget.task!.deadline;
          _existDeadline = true;
        }
      }
      isFirstCall = false;
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 242, 1),
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(247, 246, 242, 1),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => NavigationService.instance
                .navigateToPageClear(path: NavigationConstants.taskView),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                var todo = TaskModel(
                    id: DateTime.now().microsecondsSinceEpoch,
                    text: _taskText,
                    importance: _selectedImportance,
                    deadline: _dedline ?? DateTime.now(),
                    done: false,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now());
                await Provider.of<DataService>(context, listen: false)
                    .addItem(todo);
                NavigationService.instance
                    .navigateToPageClear(path: NavigationConstants.taskView);
              },
              child: Text(
                LocaleKeys.save.tr(),
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(0, 122, 255, 1)),
              ),
            ),
          ]),
      body: Form(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 104),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _taskText = value;
                          });
                        },
                        maxLines: null,
                        controller: _textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.3)),
                          hintText: LocaleKeys.textinbox.tr(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 20,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                LocaleKeys.importance.tr(),
                style:
                    TextStyle(fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 164,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DropdownButtonFormField(
                      iconSize: 0,
                      decoration: const InputDecoration(
                          fillColor: Color.fromRGBO(247, 246, 242, 1),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none),
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          child: Text(LocaleKeys.usualimportance.tr()),
                          value: 'usual',
                        ),
                        DropdownMenuItem(
                          child: Text(LocaleKeys.lowimportance.tr()),
                          value: 'low',
                        ),
                        DropdownMenuItem(
                          value: 'high',
                          child: Row(
                            children: [
                              Stack(children: [
                                const Icon(
                                  Icons.priority_high,
                                  color: Color.fromRGBO(255, 69, 58, 1),
                                  size: 20,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 7),
                                  child: Icon(
                                    Icons.priority_high,
                                    color: Color.fromRGBO(255, 69, 58, 1),
                                    size: 20,
                                  ),
                                ),
                              ]),
                              Text(
                                LocaleKeys.highimportance.tr(),
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 69, 58, 1)),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (importance) {
                        setState(() {
                          _selectedImportance = importance as String;
                        });
                      },
                      value: _selectedImportance,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox())
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(LocaleKeys.deadline.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      )),
                  const Spacer(),
                  Switch(
                      value: _existDeadline,
                      onChanged: (bool? value) async {
                        if (value == false) {
                          _deleteDeadline(context);
                        } else {
                          if (await _selectDate(context) != null) {
                            _existDeadline = true;
                          }
                        }
                      })
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      _dedline != null
                          ? _dedline!.day.toString() +
                              ' ' +
                              _dedline!.month.toString() +
                              ' ' +
                              _dedline!.year.toString()
                          : '',
                      style: const TextStyle(
                          color: Color.fromRGBO(0, 122, 255, 1)),
                    )),
              ),
            ),
            const Divider(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              thickness: 0.5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _textController.clear();
                      _selectedImportance = 'usual';
                      _dedline = null;
                      _existDeadline = false;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: _textController.text.isNotEmpty
                            ? const Color.fromRGBO(255, 59, 48, 1)
                            : const Color.fromRGBO(0, 0, 0, 0.15),
                      ),
                      const SizedBox(
                        width: 17,
                      ),
                      Text(
                        LocaleKeys.delete.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          color: _textController.text.isNotEmpty
                              ? const Color.fromRGBO(255, 59, 48, 1)
                              : const Color.fromRGBO(0, 0, 0, 0.15),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
