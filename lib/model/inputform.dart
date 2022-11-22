import 'package:hive_flutter/adapters.dart';

part 'inputform.g.dart';

// 여기서 typeId의 번호는 유니크해야 한다.
@HiveType(typeId: 1)
class InputForm{
  InputForm({
    required this.name,
    required this.age,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  int age;
}