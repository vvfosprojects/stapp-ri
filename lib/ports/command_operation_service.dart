
abstract class CommandOperationService<M> {
  
  Future<int> insert(M m) async {}

  Future<int> update(M m) async {}

  Future<int> delete(int id) async {}

}