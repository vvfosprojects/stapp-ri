
abstract class CommandOperationService<M> {
  
  Future<int> save(M m) async {}

  Future<int> update(M m) async {}

  Future<bool> delete(M m) async {}

}