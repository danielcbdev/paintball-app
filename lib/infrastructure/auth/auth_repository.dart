import 'package:firebase_auth/firebase_auth.dart';
import 'package:picospaintballzone/shared/exceptions.dart';

class AuthRepository{
  login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Nenhum usuário encontrado para esse e-mail');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta fornecida para esse usuário');
      }
    } on AuthException catch (ex) {
      throw AuthException(ex.message);
    } catch (ex) {
      throw AuthException(ex.toString());
    }
  }

  sendConfirmationCode() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Nenhum usuário encontrado para esse e-mail');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta fornecida para esse usuário');
      }
    } on AuthException catch (ex) {
      throw AuthException(ex.message);
    } catch (ex) {
      throw AuthException(ex.toString());
    }
  }

  logout() async => await FirebaseAuth.instance.signOut();

  // registerClient({required ClientSend clientSend}) async {
  //   try {
  //     final auth = FirebaseAuth.instance;
  //     final db = FirebaseFirestore.instance;
  //     String? imageProfileUrl;
  //
  //     await auth.createUserWithEmailAndPassword(
  //       email: clientSend.email,
  //       password: clientSend.password,
  //     ).then((firebaseUser) async {
  //       debugPrint('user credentials registered');
  //     }).catchError((error){
  //       throw ClientException(error.toString());
  //     });
  //
  //     await db.collection("clients").add(clientSend.toJson())
  //         .then((DocumentReference doc) =>
  //         debugPrint('client registered')
  //     ).catchError((error){
  //       throw ClientException(error.toString());
  //     });
  //
  //     if(clientSend.imageProfile != null){
  //       final storageRef = FirebaseStorage.instance.ref();
  //       final ref = storageRef.child("profile_images").child(clientSend.email);
  //
  //       await ref.putFile(clientSend.imageProfile!).whenComplete(() async {
  //         debugPrint('file has been sended!');
  //         imageProfileUrl = await ref.getDownloadURL();
  //       }).catchError((error){
  //         debugPrint('error: $error');
  //         throw PaymentSlipException(error.toString());
  //       });
  //     }
  //
  //     await auth.currentUser?.updateDisplayName(clientSend.name);
  //     if(imageProfileUrl != null){
  //       await auth.currentUser?.updatePhotoURL(imageProfileUrl);
  //     }
  //   } on ClientException catch (ex) {
  //     throw ClientException(ex.message);
  //   } catch (ex) {
  //     throw ClientException(ex.toString());
  //   }
  // }

  sendPasswordRecovery({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Nenhum usuário encontrado para esse e-mail');
      }
    } on AuthException catch (ex) {
      throw AuthException(ex.message);
    } catch (ex) {
      throw AuthException(ex.toString());
    }
  }

  Future<bool> checkIfIsLogged() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      return user != null;
    } on AuthException catch (ex) {
      throw AuthException(ex.message);
    } catch (ex) {
      throw AuthException(ex.toString());
    }
  }

  // Future<void> deleteAccount({required String password}) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     final db = FirebaseFirestore.instance;
  //
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: user?.email ?? '',
  //       password: password,
  //     );
  //
  //     final collection = FirebaseFirestore.instance.collection('clients').where('email', isGreaterThanOrEqualTo: user?.email,);
  //     var snapshots = await collection.get();
  //
  //     await db.collection("clients").doc(snapshots.docs.first.id).delete().catchError((error){
  //       throw ClientException(error.toString());
  //     });
  //
  //     await user?.delete();
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       throw AuthException('Nenhum usuário encontrado para esse e-mail');
  //     } else if (e.code == 'wrong-password') {
  //       throw AuthException('Senha incorreta fornecida para esse usuário');
  //     }
  //   } on AuthException catch (ex) {
  //     throw AuthException(ex.message);
  //   } catch (ex) {
  //     throw AuthException(ex.toString());
  //   }
  // }
}