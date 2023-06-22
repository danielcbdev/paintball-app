import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picospaintballzone/models/fidelity-card/fidelity_card.model.dart';
import 'package:picospaintballzone/shared/exceptions.dart';

class FidelityCardRepository{

  Future<FidelityCardConfigModel?> getFidelityCardConfig() async {
    try{
      FidelityCardConfigModel? fidelityCardConfigModel;
      final ref = FirebaseFirestore.instance.collection('fidelity_card');
      final querySnapshot = await ref.get();
      fidelityCardConfigModel = FidelityCardConfigModel.fromJson(querySnapshot.docs.first.data());
      return fidelityCardConfigModel;
    } catch(e){
      throw FidelityCardException(e.toString());
    }
  }

}
