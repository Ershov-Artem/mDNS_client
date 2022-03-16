part of 'dns_bloc.dart';

abstract class DnsEvent{
  const DnsEvent();

  const factory DnsEvent.startSearch() = _Start;

  const factory DnsEvent.uplDevices() = _Upload;

  const factory DnsEvent.delDevices() = _Delete;

  const factory DnsEvent.stopSearch() = _Stop;
  //map - ?
  R map<R>({
    required R Function(_Start value) startSearch,
    required R Function(_Upload value) uplDevices,
    required R Function(_Delete value) delDevices,
    required R Function(_Stop value) stopSearch,
  }){
    final it =  this;
    if (it is _Start){
      return startSearch(it);
    } else if (it is _Upload){
      return uplDevices(it);
    } else if (it is _Delete){
      return delDevices(it);
    } else if (it is _Stop){
      return stopSearch(it);
    }
    throw TypeNotInCaseError(it.runtimeType);
  }
}

class _Start extends DnsEvent{
  const _Start();
}

class _Upload extends DnsEvent{
  const _Upload();
}

class _Delete extends DnsEvent{
  const _Delete();
}

class _Stop extends DnsEvent{
  const _Stop();
}


class TypeNotInCaseError extends Error {
  final Type type;

  TypeNotInCaseError(this.type);

  @override
  String toString() => 'Function not specified for type $type';
}