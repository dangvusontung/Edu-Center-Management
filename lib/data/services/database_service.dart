import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/example_model.dart';

class DatabaseService {
  late Isar _isar;

  Future<void> openDatabase() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [ExampleModelSchema],
        directory: dir.path,
      );
    } catch (e) {
      throw DatabaseException('Failed to open database: $e');
    }
  }

  Future<void> addExampleModel(ExampleModel model) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.exampleModels.put(model);
      });
    } catch (e) {
      throw DatabaseException('Failed to add ExampleModel: $e');
    }
  }

  Future<List<ExampleModel>> getAllExampleModels() async {
    try {
      return await _isar.exampleModels.where().findAll();
    } catch (e) {
      throw DatabaseException('Failed to retrieve ExampleModels: $e');
    }
  }

  Future<void> closeDatabase() async {
    try {
      await _isar.close();
    } catch (e) {
      throw DatabaseException('Failed to close database: $e');
    }
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}
