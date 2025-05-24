import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../models/task.dart';
import 'create_task_page.dart';
import '../main.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Função para mostrar o diálogo de filtro
  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2B2B2B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Filtrar Tarefas",
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text(
                  "Todas",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  taskProvider.setFilter(null);
                  Navigator.pop(ctx);
                },
                trailing: taskProvider.currentFilter == null
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
              ),
              ...TaskStatus.values
                  .map(
                    (status) => ListTile(
                      title: Text(
                        status.statusText,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        taskProvider.setFilter(status);
                        Navigator.pop(ctx);
                      },
                      trailing: taskProvider.currentFilter == status
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navega para a página de criação usando a rota nomeada
            Navigator.pushNamed(context, createTaskRoute);
          },
          backgroundColor: const Color(0xFF2F2D2D),
          elevation: 8,
          child: Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          title: Text('Tarefas', style: theme.textTheme.headlineMedium),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.filter_list, color: Colors.white, size: 32),
                onPressed: () {
                  _showFilterDialog(context); // Chama o diálogo de filtro
                },
                tooltip: 'Filtrar Tarefas',
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          // Usa o Consumer para reconstruir a lista quando os dados mudarem
          child: Consumer<TaskProvider>(
            builder: (ctx, taskProvider, child) {
              final tasks = taskProvider.tasks;
              return tasks.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma tarefa encontrada.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: InkWell(
                            onTap: () {
                              // TODO: Implementar navegação para ViewTaskWidget
                              print('Visualizar: ${task.title}');
                            },
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: const Color(0xFF2B2B2B),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  10,
                                  10,
                                  10,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.06,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.06,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            task.taskImage, // Imagem dinâmica
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  // Fallback se a imagem não carregar
                                                  return Container(
                                                    width: 24,
                                                    height: 24,
                                                    color: Colors.grey,
                                                  );
                                                },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          task.title,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                    Checkbox(
                                      value:
                                          task.isCompleted, // Estado dinâmico
                                      onChanged: (bool? newValue) {
                                        // Chama o provider para mudar o estado
                                        taskProvider.toggleTaskCompletion(
                                          task.id,
                                        );
                                      },
                                      activeColor: Colors.blue,
                                      checkColor: Colors.white,
                                      side: BorderSide(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}
