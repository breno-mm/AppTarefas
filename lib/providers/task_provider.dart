import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../helpers/database_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = []; // A lista começa vazia
  TaskStatus? _currentFilter;
  bool _isLoading = false; // Para saber se está carregando do banco

  TaskProvider() {
    // Quando o Provider é criado carrega as tarefas do banco
    loadTasks();
  }

  List<Task> get tasks {
    if (_currentFilter == null) {
      return [..._tasks];
    } else {
      return _tasks.where((task) => task.status == _currentFilter).toList();
    }
  }

  TaskStatus? get currentFilter => _currentFilter;
  bool get isLoading => _isLoading; // status de carregamento

  // Carrega as tarefas do banco de dados
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners(); // Aviso de carregamento

    final dbHelper = DatabaseHelper.instance;
    _tasks = await dbHelper.queryAllTasks();

    _isLoading = false;
    notifyListeners(); // Avisa que terminou e atualiza a tela
  }

  // Adiciona uma nova tarefa no banco
  Future<void> addTask(
    String title,
    String description,
    TaskStatus status,
  ) async {
    const uuid = Uuid();
    final newTask = Task(
      id: uuid.v4(),
      title: title,
      description: description,
      status: status,
      isCompleted: status == TaskStatus.Concluido,
    );

    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insert(newTask);

    await loadTasks(); // Recarrega a lista do banco
  }

  // Atualiza uma tarefa existente no banco
  Future<void> updateTask(Task task) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.update(task);
    await loadTasks(); // Recarrega a lista
  }

  // Marca/Desmarca uma tarefa como concluída atualiza no banco
  Future<void> toggleTaskCompletion(String id) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      final taskToUpdate = _tasks[taskIndex];
      taskToUpdate.isCompleted = !taskToUpdate.isCompleted;
      taskToUpdate.status = taskToUpdate.isCompleted
          ? TaskStatus.Concluido
          : TaskStatus.Parado;

      await updateTask(taskToUpdate);
    }
  }

  // Deleta uma tarefa no banco
  Future<void> deleteTask(String id) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.delete(id);
    await loadTasks(); // Recarrega a lista
  }

  void setFilter(TaskStatus? status) {
    _currentFilter = status;
    notifyListeners(); // Filtro não mexe no banco só na exibição
  }
}
