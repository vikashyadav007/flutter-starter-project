extension StringExtension on String {
  String capitalizeWords() => isEmpty
      ? this
      : split(' ')
          .map((word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
          .join(' ');

  String capitalizeSentence() =>
      isEmpty ? this : "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

  String getInitials() {
    // Here "U" stand for "User"
    if (isEmpty) return 'U';
    final parts = trim().split(' ').where((part) => part.isNotEmpty).toList();
    return parts.isEmpty
        ? 'U'
        : parts.length == 1
            ? parts[0][0].toUpperCase()
            : (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}
