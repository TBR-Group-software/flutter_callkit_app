/// Contains phone verification data for authentication.
class CodeSentData {
  CodeSentData({
    required this.verificationId,
    this.resendToken,
  });

  final String verificationId;
  final int? resendToken;
}
