import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Para gerar IDs únicos
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [
    //tarefas iniciais para teste
    Task(id: '1', title: 'Tarefa de Exemplo 1', status: TaskStatus.Parado),
    Task(
      id: '2',
      title: 'Tarefa de Exemplo 2',
      status: TaskStatus.EmAndamento,
      description: "Descrição longa",
    ),
  ];

  TaskStatus? _currentFilter; // Nenhum filtro por padrão

  List<Task> get tasks {
    if (_currentFilter == null) {
      return [..._tasks]; // Retorna todas se não houver filtro
    } else {
      return _tasks.where((task) => task.status == _currentFilter).toList();
    }
  }

  TaskStatus? get currentFilter => _currentFilter;

  void addTask(String title, String description, TaskStatus status) {
    const uuid = Uuid();
    final newTask = Task(
      id: uuid.v4(), // Gera um ID único
      title: title,
      description: description,
      status: status,
      isCompleted: status == TaskStatus.Concluido,
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  void toggleTaskCompletion(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      // Se marcou como concluída, muda o status para Concluido
      // Se desmarcou, volta para Parado (ou pode manter o status anterior)
      if (_tasks[taskIndex].isCompleted) {
        _tasks[taskIndex].status = TaskStatus.Concluido;
      } else {
        _tasks[taskIndex].status =
            TaskStatus.Parado; // Ou mantenha o status anterior
      }
      notifyListeners();
    }
  }

  void setFilter(TaskStatus? status) {
    _currentFilter = status;
    notifyListeners();
  }
}
