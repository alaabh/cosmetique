part of 'produit_cubit.dart';

@immutable
sealed class ProduitState {}

final class ProduitInitial extends ProduitState {}

class ProduitLoading extends ProduitState {}

class ProduitSuccess extends ProduitState {
   final List<Map<String, dynamic>> produits;

  ProduitSuccess({required this.produits});
}

class ProduitFailure extends ProduitState {
  final String? error;
 
  ProduitFailure({required this.error});
}
