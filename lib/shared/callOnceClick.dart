typedef void CallOnceFunction();

class CallOnce {
  bool _inFunction = false;

  final CallOnceFunction function;

  CallOnce(CallOnceFunction function)
      : assert(function != null),
        function = function;

  void invoke() {
    if (_inFunction) return;

    _inFunction = true;
    function();
    _inFunction = false;
  }
}

typedef Future<void> CallOnceFuture();

class CallFutureOnce {
  bool _inFunction = false;

  final CallOnceFuture future;

  CallFutureOnce(CallOnceFuture future)
      : assert(future != null),
        future = future;

  Future<void> invoke() async {
    if (_inFunction) return;

    _inFunction = true;
    await this.future();
    _inFunction = false;
  }
}
