import 'dart:math';

int generateUniqueRandom() {
  int max = 1000000;
  int min = 6;

  if (max <= min) {
    throw Exception('Max must be greater than min.');
  }

  Set<int> usedNumbers = Set<int>();
  Random random = Random();
  int range = max - min + 1;

  if (usedNumbers.length == range) {
    throw Exception('All possible numbers have been generated.');
  }

  int randomNumber;
  do {
    randomNumber = random.nextInt(range) + min;
  } while (usedNumbers.contains(randomNumber));

  usedNumbers.add(randomNumber);
  return randomNumber;
}
