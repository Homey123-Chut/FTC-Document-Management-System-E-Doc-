
extension ShortText on String {
  String textWithDots(int maxLength) {
    if (length <= maxLength) {
      return this;
    }
    return '${substring(0, maxLength)}...';
  }
}