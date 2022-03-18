part of 'dns_bloc.dart';

class DnsState with EquatableMixin
{
  final bool isSearching;
  final Map<String, DnsDiscoveredDevice> devices;

  const DnsState(

      {required this.isSearching, required this.devices,});

  factory DnsState.initial() =>DnsState(isSearching: false, devices: Map());

  factory DnsState.search() =>DnsState(isSearching: true, devices: Map());


//   DnsState copyWith({
//     bool? isSearching,
// }){
//     return DnsState(
//       isSearching: isSearching ??this.isSearching
//     );
//   }

  DnsState copyWith({
    bool? isSearching,
    Map<String, DnsDiscoveredDevice>? devices
}){
    return DnsState(isSearching: this.isSearching, devices: devices ?? this.devices);
  }

  @override
  List<Object?> get props => [
    isSearching,
    devices
  ];
}