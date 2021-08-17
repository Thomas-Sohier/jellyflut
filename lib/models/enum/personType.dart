import 'enumValues.dart';

enum PersonType { ACTOR, DIRECTOR, GUESTSTAR, WRITER, PRODUCER }

final personTypeValues = EnumValues({
  'Actor': PersonType.ACTOR,
  'Director': PersonType.DIRECTOR,
  'GuestStar': PersonType.GUESTSTAR,
  'Producer': PersonType.PRODUCER,
  'Writer': PersonType.WRITER
});
