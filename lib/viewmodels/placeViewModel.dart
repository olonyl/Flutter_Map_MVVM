import 'package:place_finder/models/place.dart';

class PlaceViewModel {
  Place _place;
  PlaceViewModel({Place place}) : this._place = place;

  String get placeId {
    return _place.placeId;
  }

  String get photoURL {
    return _place.photoUrl;
  }

  String get name {
    return _place.name;
  }

  double get latitude {
    return _place.latitude;
  }

  double get longitude {
    return _place.longitude;
  }
}
