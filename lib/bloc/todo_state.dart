/// 어떤 상태를 가지고 있는지 다 정의해야함


/// 하나의 베이스 클래스가 있고 그 베이스 클래스를 다 상속받고 있어야함
/// 나중에 함수 파라미터로 상태를 받을 때 업캐스팅해서 받을거라서.
/// ex) test({required TodoState state}) { ... } 이런식으로 받을거라

import 'package:bloc_todo/model/todo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable /// -> 뭐지 이게
abstract class TodoState extends Equatable {}

/// 총 4개의 상태를 만들거야
/// 1. Empty  아무 것도 없다 초기의 상태를 말하는 상태
/// 2. Loading  로딩 중인 상태
/// 3. Loaded  로딩이 끝나고 데이터를 가져온 상태
/// 4. Error  에러가 발생한 상태

class Empty extends TodoState {
  @override /// -> 뭐지 이건 왜 오버라이드하지 이쿼터블때문인가?
  List<Object?> get props => [];
}

class Loading extends TodoState {
  @override
  List<Object?> get props => [];
}

class Loaded extends TodoState {
  final List<Todo> todos;

  Loaded({required this.todos});

  @override
  List<Object?> get props => [todos];
}

class Error extends TodoState {
  final String message;

  Error({required this.message});

  @override
  List<Object?> get props => [message];
}

