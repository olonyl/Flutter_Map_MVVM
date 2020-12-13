class UrlHelper {
  static String urlForReferenceImage(String photoReferenceId) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photorefence=$photoReferenceId&key=AIzaSyDz31mT_fZInv-JOt9Zt5Zg9epTmUIh7GY";
  }

  static String urlForPlaceKeywordAndLocation(
      String keyword, double latitude, double longitude) {
    return "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyDz31mT_fZInv-JOt9Zt5Zg9epTmUIh7GY";
  }
}
