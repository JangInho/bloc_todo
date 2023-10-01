import 'package:bloc_todo/model/todo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// event는 큐빗을 쓸 때는 필요없고 bloc을 쓸 때는 필요함

/// 보통 api 갯수랑 이벤트 갯수가 같음
@immutable
abstract class TodoEvent extends Equatable {}

class ListTodosEvent extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class CreateTodoEvent extends TodoEvent {
  /// api에서 투두를 받아서 이벤트를 쏴줄 때 투두를 같이 쏴줘야해서 필요해
  final String title;

  CreateTodoEvent({required this.title});

  @override
  List<Object?> get props => [title];
}

class DeleteTodoEvent extends TodoEvent {
  final Todo todo;

  DeleteTodoEvent({required this.todo});

  @override
  List<Object?> get props => [todo];
}