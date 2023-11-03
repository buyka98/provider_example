import 'package:flutter/cupertino.dart';
import 'package:provider_example/models/todo_item_model.dart';
import 'package:provider_example/repositories/todo_repository.dart';

class TodoProvider extends ChangeNotifier {
  List<DocModel> docList = [];
  final TodoRepository _todoRepository = TodoRepository();

  Future<void> getTodoList() async {
    var res = await _todoRepository.getTodo();
    List<DocModel> todoList = [];
    for (var doc in res.docs) {
      todoList.add(DocModel(
        docId: doc.id,
        todo: TodoItemModel.fromJson(doc.data()),
      ));
    }

    todoList.sort((a, b) => a.todo!.isDone ? 1 : 0);
    docList = todoList;
    notifyListeners();
  }

  void checkTodo(String? docId, bool isDone) {
    _todoRepository.checkTodo(docId: docId, isDone: isDone);
    int selectedIndex = docList.indexWhere((element) => element.docId == docId);
    docList[selectedIndex].todo = docList[selectedIndex].todo!.changeIsDone();
    docList.sort((a, b) => a.todo!.isDone ? 1 : 0);
    notifyListeners();
  }

  void editTodo(String? docId, {String? deadline, String? detail}) {
    _todoRepository.editTodo(docId: docId, deadline: deadline, detail: detail);
    int selectedIndex = docList.indexWhere((element) => element.docId == docId);
    TodoItemModel newTodo = docList[selectedIndex].todo!.copyWith(detail: detail, deadline: deadline);
    docList[selectedIndex].todo = newTodo;
    notifyListeners();
  }

  void deleteTodo(String? docId) {
    _todoRepository.deleteTodo(docId: docId);
    docList.removeWhere((element) => element.docId == docId);
    notifyListeners();
  }

  void addTodo({String? detail, String? deadline}) {
    _todoRepository.addTodo(detail: detail, deadline: deadline);
    getTodoList();
  }
}
