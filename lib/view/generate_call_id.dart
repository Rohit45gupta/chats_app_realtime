class GenerateCallId {
  static generateCallId(String otherId, String userId) {
    List<String> ids = [otherId, userId];
    ids.sort();
    return ids.join('_');
  }
}
