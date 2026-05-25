import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_clean_achitec/models/city/city_model.dart';
import 'package:doan_clean_achitec/models/tour/tour_model.dart';
import 'package:doan_clean_achitec/modules/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  final getListTourFavourite = Rxn<List<TourModel>>([]);
  final getListDestination = Rxn<List<CityModel>>([]);

  @override
  void onInit() {
    getListTourModelFavourite();
    getListModelDestination();
    super.onInit();
  }

  void getListTourModelFavourite() async {
    List<TourModel> tourList = [];
    String idUser = await _resolveUserDocId();
    if (idUser.isNotEmpty) {
      try {
        CollectionReference tourFavoriteCollection = FirebaseFirestore.instance
            .collection('userModel')
            .doc(idUser)
            .collection('favouriteTour');

        QuerySnapshot tourFavoriteSnapshot = await tourFavoriteCollection.get();

        List<String> idTourList = tourFavoriteSnapshot.docs
            .map((document) => document['idTour'] as String)
            .toList();

        if (idTourList.isEmpty) {
          getListTourFavourite.value = [];
          debugPrint('[FAVORITE] favouriteTour empty for userModel/$idUser');
          return;
        }

        final tourModelCollection =
            FirebaseFirestore.instance.collection('tourModel');

        final tourModelSnapshot = await tourModelCollection
            .where(FieldPath.documentId, whereIn: idTourList)
            .get();

        tourList = tourModelSnapshot.docs
            .map((document) => TourModel.fromJson(document))
            .toList();

        for (TourModel tour in tourList) {
          tour.isFavourite = true;
        }

        getListTourFavourite.value = tourList;

        debugPrint('[FAVORITE] Loaded favouriteTour: ${tourList.length} docs');
      } on FirebaseException catch (e) {
        _logFirebaseError('load favouriteTour userModel/$idUser', e);
      } catch (e, stackTrace) {
        debugPrint(
            '[FAVORITE][ERROR] load favouriteTour userModel/$idUser: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    } else {
      debugPrint('[FAVORITE] Cannot load favouriteTour: userDocId is empty');
    }
  }

  void getListModelDestination() async {
    List<CityModel> desList = [];
    String idUser = await _resolveUserDocId();

    if (idUser.isNotEmpty) {
      try {
        CollectionReference desFavoriteCollection = FirebaseFirestore.instance
            .collection('userModel')
            .doc(idUser)
            .collection('favourite');

        QuerySnapshot tourFavoriteSnapshot = await desFavoriteCollection.get();

        List<String> idDesList = tourFavoriteSnapshot.docs
            .map((document) => document['idDes'] as String)
            .toList();

        if (idDesList.isEmpty) {
          getListDestination.value = [];
          debugPrint('[FAVORITE] favourite city empty for userModel/$idUser');
          return;
        }

        final tourModelCollection =
            FirebaseFirestore.instance.collection('cityModel');

        final desModelSnapshot = await tourModelCollection
            .where(FieldPath.documentId, whereIn: idDesList)
            .get();

        desList = desModelSnapshot.docs
            .map((document) => CityModel.fromJson(document))
            .toList();

        for (CityModel city in desList) {
          city.isFavourite = true;
        }

        getListDestination.value = desList;

        debugPrint('[FAVORITE] Loaded favourite city: ${desList.length} docs');
      } on FirebaseException catch (e) {
        _logFirebaseError('load favourite userModel/$idUser', e);
      } catch (e, stackTrace) {
        debugPrint('[FAVORITE][ERROR] load favourite userModel/$idUser: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    } else {
      debugPrint('[FAVORITE] Cannot load favourite city: userDocId is empty');
    }
  }

  Future<void> setTourFavorite(String idTour) async {
    String idUser = await _resolveUserDocId();

    if (idUser.isNotEmpty) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        final path = 'userModel/$idUser/favouriteTour/$idTour';
        debugPrint('[FAVORITE] Save tour');
        debugPrint('[FAVORITE] current uid: ${currentUser?.uid ?? ""}');
        debugPrint('[FAVORITE] current email: ${currentUser?.email ?? ""}');
        debugPrint('[FAVORITE] userModel document id: $idUser');
        debugPrint('[FAVORITE] idTour: $idTour');
        debugPrint('[FAVORITE] path: $path');

        await FirebaseFirestore.instance.doc(path).set(
          {'idTour': idTour},
          SetOptions(merge: true),
        );
        await _refreshTourFavourite(idUser);
        debugPrint('[FAVORITE] Saved tour successfully: $path');
      } on FirebaseException catch (e) {
        _logFirebaseError('save favouriteTour idTour=$idTour user=$idUser', e);
      } catch (e, stackTrace) {
        debugPrint(
            '[FAVORITE][ERROR] save favouriteTour idTour=$idTour user=$idUser: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    } else {
      debugPrint('[FAVORITE] Cannot save tour: userDocId is empty');
    }
  }

  Future<void> setDesFavourite(String idDes) async {
    String idUser = await _resolveUserDocId();

    if (idUser.isNotEmpty) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        final path = 'userModel/$idUser/favourite/$idDes';
        debugPrint('[FAVORITE] Save city');
        debugPrint('[FAVORITE] current uid: ${currentUser?.uid ?? ""}');
        debugPrint('[FAVORITE] current email: ${currentUser?.email ?? ""}');
        debugPrint('[FAVORITE] userModel document id: $idUser');
        debugPrint('[FAVORITE] idDes: $idDes');
        debugPrint('[FAVORITE] path: $path');

        await FirebaseFirestore.instance.doc(path).set(
          {'idDes': idDes},
          SetOptions(merge: true),
        );
        await _refreshDestinationFavourite(idUser);
        debugPrint('[FAVORITE] Saved city successfully: $path');
      } on FirebaseException catch (e) {
        _logFirebaseError('save favourite idDes=$idDes user=$idUser', e);
      } catch (e, stackTrace) {
        debugPrint(
            '[FAVORITE][ERROR] save favourite idDes=$idDes user=$idUser: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    } else {
      debugPrint('[FAVORITE] Cannot save city: userDocId is empty');
    }
  }

  Future<void> removeDesFavourite(String idDes) async {
    String idUser = await _resolveUserDocId();

    if (idUser.isNotEmpty) {
      try {
        CollectionReference favouriteCollection = FirebaseFirestore.instance
            .collection('userModel')
            .doc(idUser)
            .collection('favourite');

        final path = 'userModel/$idUser/favourite/$idDes';
        debugPrint('[FAVORITE] Remove city');
        debugPrint('[FAVORITE] userModel document id: $idUser');
        debugPrint('[FAVORITE] idDes: $idDes');
        debugPrint('[FAVORITE] path: $path');

        await favouriteCollection.doc(idDes).delete();

        QuerySnapshot desSnapshot =
            await favouriteCollection.where('idDes', isEqualTo: idDes).get();

        if (desSnapshot.docs.isNotEmpty) {
          await favouriteCollection.doc(desSnapshot.docs.first.id).delete();
        }
        await _refreshDestinationFavourite(idUser);
        debugPrint('[FAVORITE] Removed city successfully: $path');
      } on FirebaseException catch (e) {
        _logFirebaseError('remove favourite idDes=$idDes user=$idUser', e);
      } catch (e, stackTrace) {
        debugPrint(
            '[FAVORITE][ERROR] remove favourite idDes=$idDes user=$idUser: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    } else {
      debugPrint('[FAVORITE] Cannot remove city: userDocId is empty');
    }
  }

  Future<void> removeTourFavourite(String idTour) async {
    String idUser = await _resolveUserDocId();

    if (idUser.isNotEmpty) {
      try {
        CollectionReference favouriteCollection = FirebaseFirestore.instance
            .collection('userModel')
            .doc(idUser)
            .collection('favouriteTour');

        final path = 'userModel/$idUser/favouriteTour/$idTour';
        debugPrint('[FAVORITE] Remove tour');
        debugPrint('[FAVORITE] userModel document id: $idUser');
        debugPrint('[FAVORITE] idTour: $idTour');
        debugPrint('[FAVORITE] path: $path');

        await favouriteCollection.doc(idTour).delete();

        QuerySnapshot desSnapshot =
            await favouriteCollection.where('idTour', isEqualTo: idTour).get();

        if (desSnapshot.docs.isNotEmpty) {
          await favouriteCollection.doc(desSnapshot.docs.first.id).delete();
        }
        await _refreshTourFavourite(idUser);
        debugPrint('[FAVORITE] Removed tour successfully: $path');
      } on FirebaseException catch (e) {
        _logFirebaseError(
            'remove favouriteTour idTour=$idTour user=$idUser', e);
      } catch (e, stackTrace) {
        debugPrint(
            '[FAVORITE][ERROR] remove favouriteTour idTour=$idTour user=$idUser: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    } else {
      debugPrint('[FAVORITE] Cannot remove tour: userDocId is empty');
    }
  }

  bool isCheckFavourite(idCity) {
    for (CityModel city in getListDestination.value ?? []) {
      if (city.id == idCity) return true;
    }
    return false;
  }

  bool isCheckFavouriteTour(idTour) {
    for (TourModel tour in getListTourFavourite.value ?? []) {
      if (tour.idTour == idTour) return true;
    }
    return false;
  }

  Future<String> _resolveUserDocId() async {
    final cachedUserDocId = homeController.userModel.value?.id ?? '';
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid ?? '';
    final email = currentUser?.email ?? '';

    debugPrint('[FAVORITE] resolve user');
    debugPrint('[FAVORITE] current uid: $uid');
    debugPrint('[FAVORITE] current email: $email');
    debugPrint('[FAVORITE] cached userModel document id: $cachedUserDocId');

    if (cachedUserDocId.isNotEmpty) {
      return cachedUserDocId;
    }

    if (uid.isEmpty && email.isEmpty) {
      return '';
    }

    try {
      if (uid.isNotEmpty) {
        final uidDoc = await FirebaseFirestore.instance
            .collection('userModel')
            .doc(uid)
            .get();
        if (uidDoc.exists) {
          await homeController.getUserDetails(uidDoc.data()?['email'] ?? email);
          debugPrint('[FAVORITE] resolved userModel by uid doc: $uid');
          return uid;
        }
      }

      if (email.isNotEmpty) {
        final snapShot = await FirebaseFirestore.instance
            .collection('userModel')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        if (snapShot.docs.isNotEmpty) {
          final userDocId = snapShot.docs.first.id;
          await homeController.getUserDetails(email);
          debugPrint('[FAVORITE] resolved userModel by email doc: $userDocId');
          return userDocId;
        }
      }
    } on FirebaseException catch (e) {
      _logFirebaseError('resolve userModel uid=$uid email=$email', e);
    } catch (e, stackTrace) {
      debugPrint('[FAVORITE][ERROR] resolve userModel: $e');
      debugPrintStack(stackTrace: stackTrace);
    }

    return uid;
  }

  Future<void> _refreshTourFavourite(String idUser) async {
    final favouriteSnapshot = await FirebaseFirestore.instance
        .collection('userModel')
        .doc(idUser)
        .collection('favouriteTour')
        .get();
    final idTourList = favouriteSnapshot.docs
        .map((document) => document['idTour'] as String)
        .toList();

    if (idTourList.isEmpty) {
      getListTourFavourite.value = [];
      return;
    }

    final tourSnapshot = await FirebaseFirestore.instance
        .collection('tourModel')
        .where(FieldPath.documentId, whereIn: idTourList)
        .get();
    final tourList = tourSnapshot.docs
        .map((document) => TourModel.fromJson(document))
        .toList();
    for (TourModel tour in tourList) {
      tour.isFavourite = true;
    }
    getListTourFavourite.value = tourList;
  }

  Future<void> _refreshDestinationFavourite(String idUser) async {
    final favouriteSnapshot = await FirebaseFirestore.instance
        .collection('userModel')
        .doc(idUser)
        .collection('favourite')
        .get();
    final idDesList = favouriteSnapshot.docs
        .map((document) => document['idDes'] as String)
        .toList();

    if (idDesList.isEmpty) {
      getListDestination.value = [];
      return;
    }

    final citySnapshot = await FirebaseFirestore.instance
        .collection('cityModel')
        .where(FieldPath.documentId, whereIn: idDesList)
        .get();
    final cityList = citySnapshot.docs
        .map((document) => CityModel.fromJson(document))
        .toList();
    for (CityModel city in cityList) {
      city.isFavourite = true;
    }
    getListDestination.value = cityList;
  }

  void _logFirebaseError(String action, FirebaseException e) {
    debugPrint('[FAVORITE][ERROR] $action');
    debugPrint('FirebaseException code: ${e.code}');
    debugPrint('message: ${e.message}');
    if (e.code == 'permission-denied') {
      debugPrint('[FAVORITE][ERROR] Firestore permission-denied. Check rules.');
    }
  }
}
