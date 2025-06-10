String formatIDRCurrency({int number = 0}) {
  String str = number.toString();
  String results = '';

  int count = 0;
  for (int i = str.length - 1; i >= 0; i--) {
    results = str[i] + results;
    count++;
    if (count % 3 == 0 && i != 0) {
      results = '.$results';
    }
  }

  return "Rp $results";
}
