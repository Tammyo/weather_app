import 'package:http/http.dart';

class Network {
  final String apiUrl;

  Network(this.apiUrl);

  Future getData() async {
    print('Calling uri: $apiUrl');

    Response response = await get(apiUrl);

    if (response.statusCode == 200) {

      return response.body;
    } else {
      print(response.statusCode);
    }
  }
}