import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../form/domain/entities/user.dart';
import '../../../form/presentation/providers/form_providers.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/delete_user.dart';

final getUsersProvider = Provider<GetUsers>((ref) {
  return GetUsers(ref.watch(userRepositoryProvider));
});

final deleteUserProvider = Provider<DeleteUser>((ref) {
  return DeleteUser(ref.watch(userRepositoryProvider));
});

final usersListProvider = FutureProvider<List<User>>((ref) async {
  final getUsers = ref.watch(getUsersProvider);
  final result = await getUsers();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (users) => users,
  );
});
