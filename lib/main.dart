import 'package:bloc_todo/bloc/todo_bloc.dart';
import 'package:bloc_todo/bloc/todo_cubit.dart';
import 'package:bloc_todo/bloc/todo_event.dart';
import 'package:bloc_todo/bloc/todo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repository/todo_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// 프로바이더 초기화
    /// 안에 있는 위젯들은 투두 블락을 쓸 수 있다.
    return BlocProvider(
      create: (BuildContext context) {
        /// bloc ver.
        // return TodoBloc(todoRepository: TodoRepository());
        /// cubit ver.
        return TodoCubit(todoRepository: TodoRepository());
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = '';

  @override
  void initState() {
    super.initState();

    /// ListTodoEvent 이벤트를 발생시키는 코드 -> 이벤트를 넣는 코드
    /// 위젯이 initState되는 시점에 블록 이벤트를 발생시키려면 부모 위젯에 BlocProvider가 있어야함 ->bloc을 사용하려는 위젯의 부모에는 BlocProvider가 있어야함
    /// bloc ver.
    // BlocProvider.of<TodoBloc>(context).add(ListTodosEvent());
    /// cubit ver.
    BlocProvider.of<TodoCubit>(context).listTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BloC Todo'),
        ),
        body: Column(
          children: [
            TextField(
              onChanged: (String value) {
                title = value;
              },
            ),

            const SizedBox(
              height: 20,
            ),

            /// BlocProvider를 통해 만든 TodoBloc을 사용하려면,
            /// BlocBuilder를 사용해야 한다.
            /// TodoBloc에서 emit 이 발생한다면 빌더 안에서 대응할 수 있다
            Expanded(
              child: BlocBuilder<TodoCubit, TodoState>(
                /// buildWhen: 이 프로퍼티는 특정 조건을 만족할 때만 빌드해라! 그치만 상태는 계속 변하고 있을건데 빌드만 해라!
                builder: (BuildContext context, state) {
                  if (state is Empty) {
                    return Container(
                      color: Colors.lightGreen,
                      child: const Text('empty'),
                    );
                  } else if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is Loaded) {
                    final todos = state.todos;

                    return ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Text(todos[index].title),
                            const Spacer(),
                            GestureDetector(onTap: () {
                              BlocProvider.of<TodoCubit>(context).deleteTodo(todos[index]);
                            }, child: const Icon(Icons.delete_forever_outlined)),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                      itemCount: todos.length,
                    );
                  } else if (state is Error) {
                    return Center(
                      child: Text(state.message),
                    );
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            /// bloc ver.
            // context.read<TodoBloc>().add(CreateTodoEvent(title: title));
            /// cubit ver.
            await context.read<TodoCubit>().createTodo(title: title);
          },
          child: const Icon(Icons.add),
        ));
  }
}
