////example taken from mani-w3w on gitb=hub: https://github.com/what3words/w3w-dart-wrapper/blob/master/example/convert_to_3wa_example.dart

import 'package:what3words/what3words.dart';

void main() async {
  // For all requests a what3words API key is needed
  var api = What3WordsV3('QQVQ4KZ6');

  // Create and execute a request to obtain a grid section within the provided bounding box
  var words = await api
      .convertTo3wa(Coordinates(51.508344, -0.12549900))
      .language('en')
      .execute();

  if (words.isSuccessful()) {
    print('Words: ${words.data()?.toJson()}');
  } else {
    var error = words.error();

    if (error == What3WordsError.BAD_COORDINATES) {
      // The coordinates provided were bad
      print('BadCoordinates: ${error!.message}');
    } else if (error == What3WordsError.BAD_LANGUAGE) {
      // The language provided was bad
      print('BadLanguage: ${error!.message}');
    } else if (error == What3WordsError.INTERNAL_SERVER_ERROR) {
      // Server Error
      print('InternalServerError: ${error!.message}');
    } else if (error == What3WordsError.NETWORK_ERROR) {
      // Network Error
      print('NetworkError: ${error!.message}');
    } else {
      print('${error!.code} : ${error.message}');
    }
  }
}
