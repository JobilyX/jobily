// import 'package:geolocator/geolocator.dart';

// extension LatLngServer on LatLng {
//   String toStringServer() {
//     return "$latitude,$longitude";
//   }
// }

// extension LatLngFromPostions on Position {
//   LatLng latLngFromPostion() {
//     return LatLng(latitude, longitude);
//   }
// }

// extension LatLngFromStringServer on String {
//   LatLng latLngFromStringServer() {
//     final List<String> strings = split(",");
//     return LatLng(double.parse(strings[0]), double.parse(strings[1]));
//   }
// }
extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
