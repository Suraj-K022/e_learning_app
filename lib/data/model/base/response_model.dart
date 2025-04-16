class ResponseModel {
  final int _status;
  final String _message;
  final dynamic _data;
  ResponseModel(this._status, this._message, this._data);
  String get message => _message;
  int get status => _status;
  dynamic get data => _data;
}
