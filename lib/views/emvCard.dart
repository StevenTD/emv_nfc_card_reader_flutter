class EmvCard {
  final List<int> aid;
  final double amount;
  final String applicationLabel;
  final int leftPinTry;
  final String state;
  final String? track1;
  final String? track2CardNumber;
  final String? track2ExpireDate; // Will store the expire date in MM/YY format
  final List<int>? track2Raw;
  final String? serviceCode1;
  final String? serviceCode2;
  final String? serviceCode3;
  final String? track2Type;

  EmvCard({
    required this.aid,
    required this.amount,
    required this.applicationLabel,
    required this.leftPinTry,
    required this.state,
    this.track1,
    this.track2CardNumber,
    this.track2ExpireDate,
    this.track2Raw,
    this.serviceCode1,
    this.serviceCode2,
    this.serviceCode3,
    this.track2Type,
  });

  factory EmvCard.fromString(String input) {
    // Patterns for parsing
    final aidPattern = RegExp(r'aid=\{(.*?)\}');
    final amountPattern = RegExp(r'amount=([-\d.]+)');
    final labelPattern = RegExp(r'applicationLabel=([^\n]+)');
    final pinPattern = RegExp(r'leftPinTry=(\d+)');
    final statePattern = RegExp(r'state=([A-Z]+)');
    final track1Pattern = RegExp(r'track1=<(.*?)>');
    final track2CardNumberPattern = RegExp(r'cardNumber=(\d+)');
    final track2ExpireDatePattern = RegExp(r'expireDate=(.*?GMT[^\n]+)');

    final track2RawPattern = RegExp(r'raw=\{(.*?)\}');
    final serviceCode1Pattern = RegExp(r'serviceCode1=([^\n]+)');
    final serviceCode2Pattern = RegExp(r'serviceCode2=([^\n]+)');
    final serviceCode3Pattern = RegExp(r'serviceCode3=([^\n]+)');
    final track2TypePattern = RegExp(r'type=([^\n]+)');

    // Extract and process expireDate field (Month/Year)
    String expireDateStr =
        track2ExpireDatePattern.firstMatch(input)?.group(1) ?? '';

    print('expireDateStr: ' + expireDateStr);
    String? formattedExpireDate;

    if (expireDateStr.isNotEmpty && expireDateStr.length > 3) {
      try {
        // Remove the weekday part (e.g., 'Mon')
        expireDateStr = expireDateStr
            .substring(4)
            .trim(); // Skip 'Mon' part and remove extra spaces
        final dateParts = expireDateStr.split(' ');

        // Ensure the parts are valid
        if (dateParts.length >= 4) {
          final monthStr = dateParts[0]; // 'Jun'
          final yearStr = dateParts[4]; // '2026'

          // Map month name to its number
          final monthMap = {
            'Jan': 1,
            'Feb': 2,
            'Mar': 3,
            'Apr': 4,
            'May': 5,
            'Jun': 6,
            'Jul': 7,
            'Aug': 8,
            'Sep': 9,
            'Oct': 10,
            'Nov': 11,
            'Dec': 12,
          };

          final month =
              monthMap[monthStr] ?? 1; // Default to January if invalid month
          final year =
              yearStr.substring(2, 4); // Get last two digits of the year

          // Construct the formatted date string in MM/YY format
          formattedExpireDate = '${month.toString().padLeft(2, '0')}/$year';

          print('Formatted Date: $formattedExpireDate'); // Output: 06/26
        }
      } catch (e) {
        print('Error parsing expireDate: $expireDateStr');
      }
    }

    return EmvCard(
      aid: aidPattern.firstMatch(input) != null
          ? aidPattern
              .firstMatch(input)!
              .group(1)!
              .split(',')
              .map((e) => int.parse(e.trim()))
              .toList()
          : [],
      amount: amountPattern.firstMatch(input) != null
          ? double.parse(amountPattern.firstMatch(input)!.group(1)!)
          : 0.0,
      applicationLabel: labelPattern.firstMatch(input)?.group(1) ?? '',
      leftPinTry: pinPattern.firstMatch(input) != null
          ? int.parse(pinPattern.firstMatch(input)!.group(1)!)
          : 0,
      state: statePattern.firstMatch(input)?.group(1) ?? '',
      track1: track1Pattern.firstMatch(input)?.group(1),
      track2CardNumber: track2CardNumberPattern.firstMatch(input)?.group(1),
      track2ExpireDate: formattedExpireDate,
      track2Raw: track2RawPattern.firstMatch(input) != null
          ? track2RawPattern
              .firstMatch(input)!
              .group(1)!
              .split(',')
              .map((e) => int.parse(e.trim()))
              .toList()
          : null,
      serviceCode1: serviceCode1Pattern.firstMatch(input)?.group(1),
      serviceCode2: serviceCode2Pattern.firstMatch(input)?.group(1),
      serviceCode3: serviceCode3Pattern.firstMatch(input)?.group(1),
      track2Type: track2TypePattern.firstMatch(input)?.group(1),
    );
  }

  @override
  String toString() {
    return '''
EmvCard(
  aid: $aid,
  amount: $amount,
  applicationLabel: $applicationLabel,
  leftPinTry: $leftPinTry,
  state: $state,
  track1: $track1,
  track2CardNumber: $track2CardNumber,
  track2ExpireDate: $track2ExpireDate,
  track2Raw: $track2Raw,
  serviceCode1: $serviceCode1,
  serviceCode2: $serviceCode2,
  serviceCode3: $serviceCode3,
  track2Type: $track2Type,
)''';
  }
}
