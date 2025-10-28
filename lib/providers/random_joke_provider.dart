import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/models/joke.dart';
import 'package:pomodoro_sczuw/services/joke_service.dart';

final randomJokeProvider = FutureProvider<Joke>((ref) async {
  return JokeService().fetchRandomJoke();
});
