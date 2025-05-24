import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class DatabaseHelper {
  // Nome do banco e tabela
  static const _databaseName = "TaskDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'tasks';

  // Nome das colunas da tabela
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnStatus = 'status';
  static const columnCompleted = 'isCompleted';

  // Classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Apenas uma referencia para o banco de dados
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDabase();
    return _database!;
  }

  // Abre o banco de dados ou cria se não existir
  _initDabase() async {
    final documentsDirectory = await getApplicationCacheDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL para criar a tabela quando o banco é criado na primeira vez
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId TEXT PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT,
            $columnStatus TEXT NOT NULL,
            $columnCompleted INTEGER NOT NULL
          )
    ''');
  }

  // -> Funções para interagir com o banco a partir daqui
}
