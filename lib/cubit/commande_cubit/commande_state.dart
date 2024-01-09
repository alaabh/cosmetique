part of 'commande_cubit.dart';

@immutable
sealed class CommandeState {}

final class CommandeInitial extends CommandeState {}
class CommandeLoading extends CommandeState {}

class CommandeSuccess extends CommandeState {
  
}

class CommandeFailure extends CommandeState {
  final String? error;
 
  CommandeFailure({required this.error});
}
class GetCommandeLoading extends CommandeState {}

class GetCommandeSuccess extends CommandeState {
  final List<Map<String, dynamic>> commandes;

  GetCommandeSuccess({required this.commandes});
  
}

class GetCommandeFailure extends CommandeState {
  final String? error;
 
  GetCommandeFailure({required this.error});
}