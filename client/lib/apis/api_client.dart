import './api_utils/get_http_client/get_http_client_default.dart'
    if (dart.library.io) './api_utils/get_http_client/get_http_client_io.dart'
    if (dart.library.html) './api_utils/get_http_client/get_http_client_html.dart'
    as get_http_client;

var apiUrl = "http://localhost:8001";
var client = get_http_client.getHttpClient();