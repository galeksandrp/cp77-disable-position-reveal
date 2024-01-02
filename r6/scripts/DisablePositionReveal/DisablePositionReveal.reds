@wrapMethod(NPCPuppet)
public final static func RevealPlayerPositionIfNeeded(ownerPuppet: wref<ScriptedPuppet>, playerID: EntityID, opt isPrevention: Bool) -> Bool {
  let characterRecord: ref<Character_Record> = TweakDBInterface.GetCharacterRecord(ownerPuppet.GetRecordID());
  let archetypeName: gamedataArchetypeType = characterRecord.ArchetypeData().Type().Type();
  let isNetrunner: Bool = ArrayContains(
    [gamedataArchetypeType.NetrunnerT1, gamedataArchetypeType.NetrunnerT2, gamedataArchetypeType.NetrunnerT3],archetypeName
  );
  if isNetrunner {
    wrappedMethod(ownerPuppet,playerID,isPrevention);
  } else {
    return false;
  }
}