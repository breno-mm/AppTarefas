import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class CreateTaskWidget extends StatefulWidget {
  const CreateTaskWidget({super.key});

  @override
  State<CreateTaskWidget> createState() => _CreateTaskWidgetState();
}

class _CreateTaskWidgetState extends State<CreateTaskWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskStatus _selectedStatus = TaskStatus.Parado; // Status inicial

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      Provider.of<TaskProvider>(context, listen: false).addTask(
        _titleController.text,
        _descriptionController.text,
        _selectedStatus,
      );
      Navigator.pop(context); // Volta para a Home Page
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
          // Adiciona um botão de voltar padrão
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Criar Tarefa', style: theme.textTheme.headlineMedium),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              // Botão de Adicionar/Salvar
              child: TextButton(
                onPressed: _saveTask, // Chama a função para salvar
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: Colors.transparent, // Cor transparente
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Adicionar', style: theme.textTheme.titleSmall),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                // Para evitar overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo Título
                    TextFormField(
                      controller: _titleController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18),
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        // Usa o tema padrão definido no main.dart
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira um título.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Campo Descrição
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
                        // Usa o tema padrão definido no main.dart
                      ),
                      maxLines: 5, // Permite múltiplas linhas
                      minLines: 3,
                    ),
                    const SizedBox(height: 30),

                    // Seleção de Status
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
                              child: Text(
                                status.statusText,
                              ), // Usa o texto do enum
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
        // O FloatingActionButton original era 'delete_forever' e voltava.
        // Removido para usar o botão de salvar na AppBar e o voltar padrão.
      ),
    );
  }
}
