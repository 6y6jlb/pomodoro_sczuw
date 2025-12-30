String formatPostponeDuration(int seconds) {
  // Если >= 1 часа и кратно часу
  if (seconds >= 3600 && seconds % 3600 == 0) {
    final hours = seconds ~/ 3600;
    return '${hours}h';
  }

  // Если >= 1 минуты и кратно минуте
  if (seconds >= 60 && seconds % 60 == 0) {
    final minutes = seconds ~/ 60;
    return '${minutes}m';
  }

  // Fallback на секунды
  return '${seconds}s';
}