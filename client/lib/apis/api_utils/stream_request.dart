import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

enum HttpMethod {
  get("GET"),
  post("POST"),
  put("PUT"),
  delete("DELETE"),
  patch("PATCH");

  final String strValue;
  const HttpMethod(this.strValue);
}

class StreamRequest<T> {
  final Uri uri;
  final HttpMethod method;
  final Map<String, String>? headers;
  final Map<String, Object?>? body;
  final T Function(Object? json) converter;

  StreamRequest(
    this.method,
    this.uri, {
    required this.headers,
    required this.body,
    required this.converter,
  });

  StreamRequest.get(
    this.uri, {
    required this.headers,
    required this.converter,
  })  : method = HttpMethod.get,
        body = null;

  StreamRequest.post(
    this.uri, {
    required this.headers,
    required this.body,
    required this.converter,
  }) : method = HttpMethod.post;

  StreamRequest.put(
    this.uri, {
    required this.headers,
    required this.body,
    required this.converter,
  }) : method = HttpMethod.put;

  StreamRequest.delete(
    this.uri, {
    required this.headers,
    required this.converter,
  })  : method = HttpMethod.delete,
        body = null;

  StreamRequest.patch(
    this.uri, {
    required this.headers,
    required this.body,
    required this.converter,
  }) : method = HttpMethod.patch;

  Stream<T> send(Client client) async* {
    final request = Request(method.strValue, uri);
    if (headers != null) request.headers.addAll(headers!);
    request.body = body == null ? '' : jsonEncode(body);
    final streamedResponse = await client.send(request);
    //get the response MIME type
    final contentType = streamedResponse.headers[HttpHeaders.contentTypeHeader];
    if (!{"application/json", "application/x-ndjson"}.contains(contentType)) {
      if (kDebugMode) {
        print(
            "[WARNING] Unexpected content type: $contentType. Should either be a single JSON value (application/json) or a stream of JSON values (application/x+ndjson).");
      }
    }

    await for (final chunk in streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .map(jsonDecode)) {
      yield converter(chunk);
    }
  }
}

class RetryStreamRequest<T> {
  final StreamRequest<T> Function() request;
  final int? maxRetries;
  final Duration retryDelay;

  RetryStreamRequest(
    this.request, {
    this.maxRetries,
    required this.retryDelay,
  });

  Stream<T> send(Client client) async* {
    for (var i = 0; maxRetries == null ? true : i < maxRetries!; i++) {
      try {
        yield* request().send(client);
        return;
      } catch (e) {
        if (i == maxRetries! - 1) rethrow;
        await Future.delayed(retryDelay);
      }
    }
  }
}
