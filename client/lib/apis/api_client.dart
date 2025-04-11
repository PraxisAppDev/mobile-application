// Import the correct HTTP client based on the platform
import 'package:praxis_afterhours/apis/api_utils/get_http_client/get_http_client_default.dart'
    if (dart.library.io) './api_utils/get_http_client/get_http_client_io.dart'
    if (dart.library.html) './api_utils/get_http_client/get_http_client_web.dart'
    as get_http_client;

//var apiUrl = "http://localhost:8001";
var apiUrl = "https://scavengerhunt.afterhoursdev.com";
var client = get_http_client.getHttpClient();
