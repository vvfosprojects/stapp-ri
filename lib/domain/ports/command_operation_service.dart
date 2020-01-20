
abstract class CommandOperationService<M> {
  
  Future<int> insert(M m);

  Future<int> update(M m);

  Future<int> delete(int id);

}