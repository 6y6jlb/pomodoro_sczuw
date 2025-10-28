import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_sczuw/utils/styles/app_text_styles.dart';
import 'package:pomodoro_sczuw/providers/random_joke_provider.dart';
import 'package:pomodoro_sczuw/services/i_10n.dart';

class JokeWidget extends ConsumerWidget {
  const JokeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jokeAsync = ref.watch(randomJokeProvider);

    return SizedBox(
      width: double.infinity,
      child: jokeAsync.when(
        data: (joke) => ElevatedButton(
          onPressed: () {
            ref.invalidate(randomJokeProvider);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(joke.setup, textAlign: TextAlign.center, style: AppTextStyles.caption),
              const SizedBox(width: 20),
              Text(joke.punchline, textAlign: TextAlign.center, style: AppTextStyles.captionBold),
            ],
          ),
        ),
        loading: () => ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))],
          ),
        ),
        error: (error, stack) => ElevatedButton(
          onPressed: () {
            ref.invalidate(randomJokeProvider);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Icon(Icons.error), const SizedBox(width: 10), Text(I10n().t.joke_error)],
          ),
        ),
      ),
    );
  }
}
