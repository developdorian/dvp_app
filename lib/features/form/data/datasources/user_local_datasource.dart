import 'package:hive/hive.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<List<UserModel>> getUsers();
  Future<void> deleteUser(int index);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String boxName = 'users';

  @override
  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(boxName);
    await box.add(user);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final box = await Hive.openBox<UserModel>(boxName);
    return box.values.toList();
  }

  @override
  Future<void> deleteUser(int index) async {
    final box = await Hive.openBox<UserModel>(boxName);
    await box.deleteAt(index);
  }
}
