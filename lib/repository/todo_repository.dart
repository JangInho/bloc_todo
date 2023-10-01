
import 'package:bloc_todo/model/todo.dart';

/// GET - ListTodo
/// POST - CreateTodo
/// DELETE - DeleteTodo
class TodoRepository {

  Future<List<Map<String, dynamic>>> listTodo() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        'id': 1,
        'title': 'Todo 1',
        'createdAt': '2021-10-01T00:00:00.000Z',
      },
      {
        'id': 2,
        'title': 'Todo 2',
        'createdAt': '2021-10-02T00:00:00.000Z',
      },
      {
        'id': 3,
        'title': 'Todo 3',
        'createdAt': '2021-10-03T00:00:00.000Z',
      },
    ];
  }

  Future<Map<String, dynamic>> createTodo({required Todo todo}) async {
    await Future.delayed(const Duration(seconds: 1));

    return todo.toJson();
  }

  Future<Map<String, dynamic>> deleteTodo({
    required Todo todo,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

   return todo.toJson();
  }

}