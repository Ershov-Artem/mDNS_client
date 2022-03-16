part of 'dns_bloc.dart';

class DnsState with EquatableMixin
{
  final bool isSearching;

  const DnsState({required this.isSearching});

  factory DnsState.initial() =>DnsState(isSearching: false);

  DnsState copyWith({
    bool? isSearching,
}){
    return DnsState(
      isSearching: isSearching ??this.isSearching
    );
  }

  @override
  List<Object?> get props => [
    isSearching
  ];
}