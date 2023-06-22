/// Converts the phone number from +380990887766 string to 380990887766
/// integer.
int? parsePhoneNumber(String phoneNumber) {
  final phoneNumberWithoutCharacters =
      phoneNumber.replaceAll(RegExp('[^0-9]'), '');
  final phone = int.tryParse(phoneNumberWithoutCharacters);
  return phone;
}
