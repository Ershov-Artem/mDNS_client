class DnsState
   // with EquatableMixin
{
  final bool isSearching;

  DnsState({required this.isSearching});

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