import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormPage extends StatefulWidget {
  // Modo de edição
  final Task? taskToEdit;

  const TaskFormPage({super.key, this.taskToEdit});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskStatus _selectedStatus = TaskStatus.Parado;
  bool _isEditing = false; // Para saber se estamos editando ou criando

  @override
  void initState() {
    super.initState();
    // Se receber uma tarefa preenche os campos e marca como edição
    if (widget.taskToEdit != null) {
      _isEditing = true;
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description;
      _selectedStatus = widget.taskToEdit!.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Função para salvar cria ou atualiza
  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      if (_isEditing) {
        // Atualiza a tarefa existente
        final updatedTask = Task(
          id: widget.taskToEdit!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          status: _selectedStatus,
          isCompleted: _selectedStatus == TaskStatus.Concluido,
        );
        await provider.updateTask(updatedTask);
      } else {
        // Cria uma nova tarefa
        await provider.addTask(
          _titleController.text,
          _descriptionController.text,
          _selectedStatus,
        );
      }
      // Volta pra Home
      if (mounted) Navigator.pop(context);
    }
  }

  // Função para deletar com confirmação
  void _deleteTask() async {
    // Mostra um alerta antes de apagar
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2B2B2B),
        title: const Text(
          'Confirmar Exclusão',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Tem certeza que deseja excluir esta tarefa?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    // Se o usuário confirmou (e está editando) apaga e volta
    if (confirmed == true && _isEditing) {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      await provider.deleteTask(widget.taskToEdit!.id);
      if (mounted) Navigator.pop(context); // Volta pra Home
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            _isEditing ? 'Editar Tarefa' : 'Criar Tarefa',
            style: theme.textTheme.headlineMedium,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextButton(
                onPressed: _saveTask,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  _isEditing ? 'Salvar' : 'Adicionar',
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2,
        ),
        // O botão flutuante só aparece se estiver editando
        floatingActionButton: _isEditing
            ? FloatingActionButton(
                onPressed: _deleteTask,
                backgroundColor: Colors.redAccent.shade700,
                elevation: 8,
                child: const Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 32,
                ),
              )
            : null, // Se não estiver editando não mostra nada
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      autofocus: !_isEditing,
                      textCapitalization: TextCapitalization.sentences,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18),
                      decoration: const InputDecoration(labelText: 'Título'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira um título.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Descrição...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      minLines: 3,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Status da Tarefa:',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F2D2D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<TaskStatus>(
                          value: _selectedStatus,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF2F2D2D),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          style: theme.textTheme.bodyMedium,
                          items: TaskStatus.values.map((TaskStatus status) {
                            return DropdownMenuItem<TaskStatus>(
                              value: status,
                              child: Text(status.statusText),
                            );
                          }).toList(),
                          onChanged: (TaskStatus? newValue) {
                            setState(() {
                              _selectedStatus = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
