import 'package:rfh/app_services/connection.dart';
import '../app_config/app_end_points.dart';

class UserService {
  loginService(dynamic, requestDate) async {
    Connection connection = Connection();
    var url = EndPoints.login;
    var response = await connection.post(url, requestDate);
    return response;
  }
}
