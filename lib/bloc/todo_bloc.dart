import 'package:bloc_todo/bloc/todo_event.dart';
import 'package:bloc_todo/bloc/todo_state.dart';
import 'package:bloc_todo/model/todo.dart';
import 'package:bloc_todo/repository/todo_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// bloc ver.

/// 모든 비즈니스 로직을 여기로 모아버릴거고 레포지토리도 여기서만 쓸 수 있어
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  /// dependency injection ! 안에서만 쓸 수 있게... ?
  /// 근데 그냥 필드에 박아두면 되지 않나 ? 하는데 tdd에서 테스트 코드를 작성하기 좋다던데 ?

  TodoBloc({required this.todoRepository}) : super(Empty());

  /// 기본 state를 수퍼 생성자에 넣어줘야함
  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    /// 1. 어떤 이벤트인지 확인해야함
    /// is 를 쓸 수 있는 이유가 equatable을 상속받았기 때문임? ㄴㄴ == 가 equatable is 는 그냥 타입 체크임
    if (event is ListTodosEvent) {
      yield* _mapListTodosEvent(event);
    } else if (event is CreateTodoEvent) {
      yield* _mapCreateTodoEvent(event);
    } else if (event is DeleteTodoEvent) {
      yield* _mapDeleteTodoEvent(event);
    } else {
      /// 에러를 던져줘야함
    }
  }

  Stream<TodoState> _mapListTodosEvent(ListTodosEvent event) async* {
    /// 이부분이 이제 ui랑 맞물리는 부분이니까 에러 처리를 잘해줘야함
    try {
      yield Loading();

      final res = await todoRepository.listTodo();

      final todos = res.map<Todo>((e) => Todo.fromJson(e)).toList();

      yield Loaded(todos: todos);
    } catch (e) {
      /// 왜 여긴 별이 없을까
      yield Error(message: e.toString());
    }
  }

  Stream<TodoState> _mapCreateTodoEvent(CreateTodoEvent event) async* {
    try {
      /// bloc으로 상속받는 클래스는 마지막으로 yield된 상태를 가지고있음
      /// 그래서 현재 상태를 알아내는 로직이 필요하지

      if (state is Loaded) {
        final parsedState = (state as Loaded);

        Todo newTodo =
            Todo(id: parsedState.todos.last.id + 1, title: event.title, createdAt: DateTime.now().toString());

        /// optimistic response -> 보여지는 건 타이틀 뿐이니 나중에 응답 받아서 아이디를 갈아치운다
        final prevTodos = [...parsedState.todos];
        final newTodos = [...prevTodos, newTodo];
        yield Loaded(todos: newTodos);

        final res = await todoRepository.createTodo(todo: newTodo);
        yield Loaded(todos: [...prevTodos, Todo.fromJson(res)]);
      } else if (state is Empty) {
      } else if (state is Loading) {
      } else if (state is Error) {}
    } catch (e) {}
  }

  Stream<TodoState> _mapDeleteTodoEvent(DeleteTodoEvent event) async* {
    try {
      if (state is Loaded) {
        /// optimistic response
        final newTodos = (state as Loaded).todos.where((element) => element.id != event.todo.id).toList();
        yield Loaded(todos: newTodos);

        await todoRepository.deleteTodo(todo: event.todo);
        /// 만약 리프레시한다면 ...?
      }
    } catch (e) {}
  }
}
