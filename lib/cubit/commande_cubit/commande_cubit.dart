import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

part 'commande_state.dart';

class CommandeCubit extends Cubit<CommandeState> {
  final box = GetStorage();
  CommandeCubit() : super(CommandeInitial());

  Future<void> addCommande(String product, String imgUrl, String somme,
      String quantity, String price) async {
    try {
      emit(CommandeLoading());

      await FirebaseFirestore.instance.collection('commandes').doc().set({
        'product': product,
        'imgUrl': imgUrl,
        'somme': somme,
        'quantity': quantity,
        'price': price,
        'date': FieldValue.serverTimestamp(),
        'userId': box.read("userId"),
      });

      emit(CommandeSuccess());
    } on FirebaseException catch (e) {
      print(e);
      emit(CommandeFailure(error: e.message));
    } catch (e) {
      emit(CommandeFailure(error: 'An unexpected error occurred'));
    }
  }

  Future<void> getcommande() async {
    try {
      emit(GetCommandeLoading());
      final snapshot = await FirebaseFirestore.instance
          .collection('commandes')
          .where('userId', isEqualTo: box.read("userId"))
          .orderBy('date', descending: true)
          .get();

      final commandes = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      emit(GetCommandeSuccess(commandes: commandes));
    } on FirebaseException catch (e) {
      print(e);
      emit(GetCommandeFailure(error: e.message));
    } catch (e) {
      emit(GetCommandeFailure(error: 'An unexpected error occurred'));
    }
  }
}
