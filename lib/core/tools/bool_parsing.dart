extension BoolParsing on String {
  bool parseBool() {
    if(this != null) {
      return toLowerCase() == 'true';
    } else {
      return false;
    }
  }
}