import 'package:fetch_client/fetch_client.dart';
import 'package:http/http.dart' as http;

http.Client getHttpClient() {
  return FetchClient(
    mode: RequestMode.cors,
    credentials: RequestCredentials.cors,
    cache: RequestCache.byDefault,
    referrer: '',
    integrity: '',
    redirectPolicy: RedirectPolicy.alwaysFollow,
    streamRequests: false,
  );
}