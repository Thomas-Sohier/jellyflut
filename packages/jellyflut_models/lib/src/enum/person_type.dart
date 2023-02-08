enum PersonType {
  ACTOR('Actor'),
  DIRECTOR('Director'),
  GUESTSTAR('GuestStar'),
  WRITER('Producer'),
  PRODUCER('Writer');

  final String value;
  const PersonType(this.value);

  static PersonType fromString(String value) {
    return PersonType.values.firstWhere((type) => type.value.toLowerCase() == value.toLowerCase());
  }
}
