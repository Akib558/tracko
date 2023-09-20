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

String todaysDateFormatted() {
  // today
  var dateTimeObject = DateTime.now();

  // year in the format yyyy
  String year = dateTimeObject.year.toString();

  // month in the format mm
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day in the format dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // final format
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}

// convert string yyyymmdd to DateTime object
DateTime createDateTimeObject(String yyyymmdd) {
  int yyyy = int.parse(yyyymmdd.substring(0, 4));
  int mm = int.parse(yyyymmdd.substring(4, 6));
  int dd = int.parse(yyyymmdd.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

// convert DateTime object to string yyyymmdd
String convertDateTimeToString(DateTime dateTime) {
  // year in the format yyyy
  String year = dateTime.year.toString();

  // month in the format mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day in the format dd
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // final format
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}

String calculateHabitPercentages(List todaysHabitList) {
  int countCompleted = 0;
  int lengthOfDaily = 0;
  for (int i = 0; i < todaysHabitList.length; i++) {
    if (todaysHabitList[i][1] == true && todaysHabitList[i][2].contains(2)) {
      countCompleted++;
    }
    if (todaysHabitList[i][2].contains(2)) {
      lengthOfDaily++;
    }
  }

  String percent = todaysHabitList.isEmpty
      ? '0.0'
      : (countCompleted / lengthOfDaily).toStringAsFixed(1);

  // key: "PERCENTAGE_SUMMARY_yyyymmdd"
  // value: string of 1dp number between 0.0-1.0 inclusive
  // _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  return percent;
}

Map<DateTime, int> loadHeatMap(Map<String, dynamic> historyList) {
  Map<DateTime, int> heatMapDataSet = {};

  DateTime startDate = createDateTimeObject(historyList["start_date"][0]);

  // count the number of days to load
  int daysInBetween = DateTime.now().difference(startDate).inDays;

  // go from start date to today and add each percentage to the dataset
  // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
  for (int i = 0; i < daysInBetween + 1; i++) {
    String yyyymmdd = convertDateTimeToString(
      startDate.add(Duration(days: i)),
    );

    double strengthAsPercent =
        double.parse(calculateHabitPercentages(historyList[yyyymmdd])
            // _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
            );

    // split the datetime up like below so it doesn't worry about hours/mins/secs etc.

    // year
    int year = startDate.add(Duration(days: i)).year;

    // month
    int month = startDate.add(Duration(days: i)).month;

    // day
    int day = startDate.add(Duration(days: i)).day;

    final percentForEachDay = <DateTime, int>{
      DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
    };

    heatMapDataSet.addEntries(percentForEachDay.entries);
    print(heatMapDataSet);
  }
  return heatMapDataSet;
}
