import 'package:provider_example/providers/todo_provider.dart';
import 'package:provider_example/repositories/todo_repository.dart';
import 'package:provider_example/screens/todo/todo_add_screen.dart';
import 'package:provider_example/screens/todo/todo_edit_screen.dart';
import 'package:provider_example/screens/todo/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TodoRepository todoRepository = TodoRepository();
  TodoProvider provider = TodoProvider();
  @override
  void initState() {
    provider.getTodoList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => provider,
      child: Scaffold(
        appBar: AppBar(
          title: Text("To do "),
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                      value: provider,
                      child: TodoAddScreen(),
                    )));
          },
          child: Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
          child: builder(),
        ),
      ),
    );
  }

  Widget builder() {
    return Builder(
      builder: (BuildContext context) {
        return ListView.builder(
            itemCount: context.watch<TodoProvider>().docList.length,
            itemBuilder: (context, int i) {
              var doc = context.watch<TodoProvider>().docList[i];
              return TodoItem(
                todo: doc.todo!,
                docId: doc.docId,
                handleEdit: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                              value: provider,
                              child: TodoEditScreen(
                                todo: doc.todo!,
                                docId: doc.docId,
                              ),
                            )),
                  );
                },
              );
            });
      },
    );
  }
}
