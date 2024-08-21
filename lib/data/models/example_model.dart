import 'package:isar/isar.dart';

part 'example_model.g.dart';

@Collection()
class ExampleModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String name;

  String? description;

  ExampleModel({
    required this.name,
    this.description,
  });
}
