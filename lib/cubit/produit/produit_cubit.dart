import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'produit_state.dart';

class ProduitCubit extends Cubit<ProduitState> {
  ProduitCubit() : super(ProduitInitial());

  Future<void> getProduit() async {
    try {
      emit(ProduitLoading());
      final snapshot =
          await FirebaseFirestore.instance.collection('produit').get();

      final produits = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      emit(ProduitSuccess(produits: produits));
    } on FirebaseException catch (e) {
      print(e);
      emit(ProduitFailure(error: e.message));
    } catch (e) {
      emit(ProduitFailure(error: 'An unexpected error occurred'));
    }
  }
}
