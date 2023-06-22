import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:picospaintballzone/models/user/user.model.dart';
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

  registerUser({required String name, required String phone, required String cpf, required String email, required String password,}) async {
    try {
      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();
      String? uid;

      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((firebaseUser) async {
        debugPrint('user credentials registered');
        uid = firebaseUser.user?.uid;
      }).catchError((error){
        throw AuthException(error.toString());
      });

      final user = UserModel(
        uid: uid,
        name: name,
        phone: phone,
        email: email,
        cpf: cpf,
        fcmToken: token,
        isAdm: false,
        qtdPoints: 0,
      );

      await db.collection("users").doc(uid).set(user.toJson()).then((value) {
        debugPrint('user has been registered');
      });
    } on AuthException catch (ex) {
      throw AuthException(ex.message);
    } catch (ex) {
      throw AuthException(ex.toString());
    }
  }

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