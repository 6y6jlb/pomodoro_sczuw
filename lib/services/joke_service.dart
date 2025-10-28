import 'package:dio/dio.dart';
import 'package:pomodoro_sczuw/models/joke.dart';

class JokeService {
  Future<Joke> fetchRandomJoke() async {
    final response = await Dio().get<Map<String, Object?>>('https://official-joke-api.appspot.com/random_joke');

    return Joke.fromJson(response.data!);
  }
}