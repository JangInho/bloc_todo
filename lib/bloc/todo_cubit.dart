import 'package:bloc_todo/bloc/todo_state.dart';
import 'package:bloc_todo/model/todo.dart';
import 'package:bloc_todo/repository/todo_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// cubit은 이벤트를 사용할 필요가 없음.
class TodoCubit extends Cubit<TodoState> {
  /// DI
  final TodoRepository todoRepository;


  TodoCubit({required this.todoRepository}) : super(Empty());

  listTodo() async {
    /// 이부분이 이제 ui랑 맞물리는 부분이니까 에러 처리를 잘해줘야함
    try {
      // yield Loading(); /// cubit은 yield를 사용할 필요가 없고 큐빗 자체의 emit으로 대체
      emit(Loading());

      final res = await todoRepository.listTodo();

      final todos = res.map<Todo>((e) => Todo.fromJson(e)).toList();

      // yield Loaded(todos: todos);
      emit(Loaded(todos: todos));
    } catch (e) {
      /// 왜 여긴 별이 없을까
      // yield Error(message: e.toString());
      emit(Error(message: e.toString()));
    }
  }

  createTodo({required String title}) async {
    try {
      /// bloc으로 상속받는 클래스는 마지막으로 yield된 상태를 가지고있음
      /// 그래서 현재 상태를 알아내는 로직이 필요하지

      if (state is Loaded) {
        final parsedState = (state as Loaded);

        Todo newTodo =
        // Todo(id: parsedState.todos.last.id + 1, title: event.title, createdAt: DateTime.now().toString());
        Todo(id: parsedState.todos.last.id + 1, title: title, createdAt: DateTime.now().toString());

        /// optimistic response -> 보여지는 건 타이틀 뿐이니 나중에 응답 받아서 아이디를 갈아치운다
        final prevTodos = [...parsedState.todos];
        final newTodos = [...prevTodos, newTodo];
        // yield Loaded(todos: newTodos);
        emit(Loaded(todos: newTodos));

        final res = await todoRepository.createTodo(todo: newTodo);
        // yield Loaded(todos: [...prevTodos, Todo.fromJson(res)]);
        emit(Loaded(todos: [...prevTodos, Todo.fromJson(res)]));
      }
    } catch (e) {}
  }

  deleteTodo(Todo todo) async {
    try {
      if (state is Loaded) {
        /// optimistic response
        final newTodos = (state as Loaded).todos.where((element) => element.id != todo.id).toList();
        // yield Loaded(todos: newTodos);
        emit(Loaded(todos: newTodos));

        await todoRepository.deleteTodo(todo: todo);
        /// 만약 리프레시한다면 ...?
      }
    } catch (e) {}
  }

}