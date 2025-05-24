import 'package:flutter/material.dart';

// Enum para representar o status da tarefa
enum TaskStatus { Parado, EmAndamento, Atrasado, Concluido }

// Extensão para adicionar funcionalidades ao enum TaskStatus
extension TaskStatusExtension on TaskStatus {
  String get statusText {
    switch (this) {
      case TaskStatus.Parado:
        return 'Parado';
      case TaskStatus.EmAndamento:
        return 'Em Andamento';
      case TaskStatus.Atrasado:
        return 'Atrasado';
      case TaskStatus.Concluido:
        return 'Concluído';
      default:
        return 'Parado';
    }
  }

  String get statusImage {
    switch (this) {
      case TaskStatus.Parado:
        return 'assets/images/redcircle.png';
      case TaskStatus.EmAndamento:
        return 'assets/images/yellowcircle.png';
      case TaskStatus.Atrasado:
        return 'assets/images/orangecircle.png';
      case TaskStatus.Concluido:
        return 'assets/images/greencircle.png';
      default:
        return 'assets/images/redcircle.png';
    }
  }

  // Converte a string do banco para o enum
  static TaskStatus fromString(String statusStr) {
    return TaskStatus.values.firstWhere(
      (e) => e.toString() == 'TaskStatus.$statusStr',
      orElse: () => TaskStatus.Parado,
    );
  }
}

class Task {
  final String id;
  String title;
  String description;
  TaskStatus status;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.status = TaskStatus.Parado,
    this.isCompleted = false,
  });

  String get taskImage {
    if (isCompleted) return TaskStatus.Concluido.statusImage;
    return status.statusImage;
  }

  // -> Novas funções para o Banco de Dados

  // Converte a Tarefa para um Map (para salvar no DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Converte um Map vindo do DB para uma Tarefa
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      status: TaskStatusExtension.fromString(map['status']),
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
