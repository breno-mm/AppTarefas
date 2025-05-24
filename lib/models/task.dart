import 'package:flutter/material.dart';

// Enum para representar o status da tarefa
enum TaskStatus { Parado, EmAndamento, Atrasado, Concluido }

// Extensão para adicionar funcionalidades ao enum TaskStatus
extension TaskStatusExtension on TaskStatus {
  String get statusText {
    switch (this) {
      // 'this' se refere à própria instância do enum (Parado, EmAndamento, etc.)
      case TaskStatus.Parado:
        return 'Parado';
      case TaskStatus.EmAndamento:
        return 'Em Andamento';
      case TaskStatus.Atrasado:
        return 'Atrasado';
      case TaskStatus.Concluido:
        return 'Concluído';
      default:
        return 'Parado'; // Fallback
    }
  }

  // (Opcional) Podemos mover a lógica da imagem para cá também, se preferir
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

  // Mapeia o status para o nome da imagem, considerando 'isCompleted'
  String get taskImage {
    // Se estiver concluído, a imagem é sempre verde, independentemente do status original
    if (isCompleted) return TaskStatus.Concluido.statusImage;
    // Caso contrário, usa a imagem do status atual
    return status.statusImage;
  }
}
