enum FaceValidationTypes {
  smile,
  blink,
  turnHeadRight,
  turnHeadLeft,
  headStraight;

  static final List<List<FaceValidationTypes>> predefinedFlows = [
    [FaceValidationTypes.blink, FaceValidationTypes.turnHeadRight, FaceValidationTypes.smile],
    [FaceValidationTypes.blink, FaceValidationTypes.turnHeadLeft, FaceValidationTypes.smile],
    [FaceValidationTypes.smile, FaceValidationTypes.turnHeadRight, FaceValidationTypes.blink],
    [FaceValidationTypes.smile, FaceValidationTypes.turnHeadLeft, FaceValidationTypes.blink],
    [FaceValidationTypes.blink, FaceValidationTypes.turnHeadRight, FaceValidationTypes.headStraight],
    [FaceValidationTypes.blink, FaceValidationTypes.turnHeadLeft, FaceValidationTypes.headStraight],
    [FaceValidationTypes.smile, FaceValidationTypes.turnHeadRight, FaceValidationTypes.headStraight],
    [FaceValidationTypes.smile, FaceValidationTypes.turnHeadLeft, FaceValidationTypes.headStraight],
    [FaceValidationTypes.blink, FaceValidationTypes.smile, FaceValidationTypes.headStraight],
    [FaceValidationTypes.smile, FaceValidationTypes.blink, FaceValidationTypes.headStraight],
  ];
}
