class ItemTask {
  int id = 0;
  String TextTask = '';
  bool IsExec = false;

  ItemTask.create(this.id, this.TextTask, this.IsExec) ;

  @override
  String toString() {
    return 'id = $id TextTask = $TextTask IsExec = $IsExec ';
  }
}
