import 'package:done/core/init/lang/locale_keys.dart';
import 'package:done/core/init/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/init/data_service/data_service.dart';
import '../../data/models/hive_task_model.dart';

import 'widgets/app_bar.dart';

class TaskViewPage extends StatefulWidget {
  const TaskViewPage({super.key});

  @override
  State<TaskViewPage> createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 242, 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 122, 255, 1),
        onPressed: () => NavigationService.instance.navigateToPage(
          path: NavigationConstants.taskCreateView,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
          future: Future.wait([
            Provider.of<DataService>(context).init(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Consumer<DataService>(
                    builder: (context, dataservice, widget) {
                  return NestedScrollView(
                    headerSliverBuilder: ((context, innerBoxIsScrolled) {
                      return [
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverPersistentHeader(
                            delegate: MySliverAppBar2(
                              dataservice,
                            ),
                            pinned: true,
                          ),
                        )
                      ];
                    }),
                    body: Builder(
                      builder: (BuildContext context) {
                        return CustomScrollView(
                          key: const PageStorageKey<String>('name'),
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                            ),
                            SliverPadding(
                                padding: const EdgeInsets.all(8.0),
                                sliver: TodoList(
                                  dataservice: dataservice,
                                )),
                          ],
                        );
                      },
                    ),
                  );
                });
              } else {
                return Center(child: Text(LocaleKeys.error.tr()));
              }
            } else {
              return Center(
                child: Text(LocaleKeys.openinghive.tr()),
              );
            }
          }),
    );
  }
}

class TodoList extends StatelessWidget {
  final DataService dataservice;
  TodoList({required this.dataservice, super.key});
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: dataservice.notes.length + 1,
                controller: _scrollController,
                itemBuilder: ((context, index) {
                  if (index != dataservice.notes.length) {
                    if (dataservice.withoutDone) {
                      if (!dataservice.notes[index].done) {
                        return TaskItem(
                            task: dataservice.notes[index], taskKey: index);
                      } else {
                        return const SizedBox();
                      }
                    } else {
                      return TaskItem(
                          task: dataservice.notes[index], taskKey: index);
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(52, 14, 55, 14),
                    child: TextField(
                      controller: _textController,
                      onEditingComplete: () =>
                          Provider.of<DataService>(context, listen: false)
                              .addItem(TaskModel(
                                  id: 67,
                                  text: _textController.text,
                                  importance: LocaleKeys.lowimportance.tr(),
                                  deadline: DateTime.now(),
                                  done: false,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now())),
                      decoration: InputDecoration(
                          hintText: LocaleKeys.somenew.tr(),
                          hintStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.3)),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  );
                }))));
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({required this.taskKey, required this.task, super.key});
  final TaskModel task;
  final int taskKey;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool _checked;
  Future<void> _changeDone(BuildContext context) async {
    await Provider.of<DataService>(context, listen: false)
        .changeCheck(task: widget.task, key: widget.taskKey);
    setState(() {
      _checked = !_checked;
    });
  }

  Future<void> _deleteTask(BuildContext context) async {
    await Provider.of<DataService>(context, listen: false)
        .removeItemAtId(widget.task.id);
  }

  @override
  void initState() {
    if (widget.task.done) {
      _checked = true;
    } else {
      _checked = false;
    }
    super.initState();
  }

  double _progress = 0;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Dismissible(
          key: ValueKey<int>(widget.task.id),
          onUpdate: (details) {
            setState(() {
              _progress = details.progress;
            });
          },
          background: Container(
            color: const Color.fromRGBO(52, 199, 89, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Icon(
                  Icons.check,
                  color: Colors.white,
                )
              ],
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              _changeDone(context);
              return false;
            } else if (direction == DismissDirection.endToStart) {
              _deleteTask(context);
              return true;
            }
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 60,
              maxHeight: 220,
            ),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      widget.task.importance == 'high'
                          ? Container(
                              color: const Color.fromRGBO(255, 69, 58, 0.2),
                              height: 19,
                              width: 19,
                            )
                          : const SizedBox(),
                      Checkbox(
                        side: _checked
                            ? const BorderSide(
                                color: Color.fromRGBO(52, 199, 89, 1), width: 2)
                            : widget.task.importance == 'high'
                                ? const BorderSide(
                                    color: Color.fromRGBO(255, 69, 58, 1),
                                    width: 2)
                                : const BorderSide(
                                    color: Color.fromRGBO(0, 0, 0, 0.2),
                                    width: 2),
                        checkColor: Colors.white,
                        activeColor: const Color.fromRGBO(52, 199, 89, 1),
                        value: _checked,
                        onChanged: (bool? value) async {
                          await _changeDone(context);
                        },
                      ),
                    ],
                  ),
                  widget.task.importance == 'high'
                      ? Padding(
                          padding: const EdgeInsets.only(top: 13),
                          child: Stack(children: [
                            const Icon(
                              Icons.priority_high,
                              color: Colors.red,
                              size: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 7),
                              child: Icon(
                                Icons.priority_high,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ]),
                        )
                      : widget.task.importance == 'low'
                          ? const Padding(
                              padding: EdgeInsets.only(
                                  top: 13, left: 3.5, right: 3.5),
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.grey,
                                size: 20,
                              ),
                            )
                          : const SizedBox(
                              width: 10,
                            ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            widget.task.text,
                            style: widget.task.done
                                ? const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(0, 0, 0, 0.3),
                                    decoration: TextDecoration.lineThrough)
                                : const TextStyle(
                                    fontSize: 16,
                                  ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        widget.task.deadline != null
                            ? Text(
                                (widget.task.deadline.day < 10
                                        ? '0' +
                                            widget.task.deadline.day.toString()
                                        : widget.task.deadline.day.toString()) +
                                    '.' +
                                    (widget.task.deadline.month < 10
                                        ? '0' +
                                            widget.task.deadline.month
                                                .toString()
                                        : widget.task.deadline.month
                                            .toString()) +
                                    '.' +
                                    widget.task.deadline.year.toString(),
                                style: const TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.3)),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 15, top: 10, left: 15),
                    child: Icon(
                      Icons.info_outline,
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      size: 25,
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
