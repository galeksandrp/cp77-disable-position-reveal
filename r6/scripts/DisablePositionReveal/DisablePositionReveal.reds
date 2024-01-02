@replaceMethod(NPCPuppet)
public final static func RevealPlayerPositionIfNeeded(ownerPuppet: wref<ScriptedPuppet>, playerID: EntityID, opt isPrevention: Bool) -> Bool {
  let evt: ref<HackPlayerEvent>;
  let hackingMinigameBB: ref<IBlackboard>;
  let ownerHighLevelState: gamedataNPCHighLevelState;
  let player: wref<PlayerPuppet>;
  if !IsDefined(ownerPuppet) || !EntityID.IsDefined(playerID) {
    return false;
  };
  if StatusEffectSystem.ObjectHasStatusEffectWithTag(ownerPuppet, n"CommsNoiseJam") {
    return false;
  };
  player = GameInstance.FindEntityByID(ownerPuppet.GetGame(), playerID) as PlayerPuppet;
  if !IsDefined(player) || player.IsInCombat() || player.IsReplacer() || player.IsBeingRevealed() {
    return false;
  };
  ownerHighLevelState = ownerPuppet.GetHighLevelStateFromBlackboard();
  if ScriptedPuppet.IsBoss(ownerPuppet) && NotEquals(ownerHighLevelState, gamedataNPCHighLevelState.Combat) {
    return false;
  };
  evt = new HackPlayerEvent();
  evt.targetID = player.GetEntityID();
  evt.netrunnerID = ownerPuppet.GetEntityID();
  evt.objectRecord = TweakDBInterface.GetObjectActionRecord(isPrevention ? t"AIQuickHack.PreventionHackRevealPosition" : t"AIQuickHack.HackRevealPosition");
  evt.showDirectionalIndicator = false;
  evt.revealPositionAction = true;
  // Begin DisableRevealPositionHack code
  let characterRecord: ref<Character_Record> = TweakDBInterface.GetCharacterRecord(ownerPuppet.GetRecordID());
  let archetypeName: gamedataArchetypeType = characterRecord.ArchetypeData().Type().Type();
  let isNetrunner: Bool = ArrayContains(
    [gamedataArchetypeType.NetrunnerT1, gamedataArchetypeType.NetrunnerT2, gamedataArchetypeType.NetrunnerT3],
    archetypeName
  );
  if IsDefined(evt.objectRecord) && isNetrunner {
  // if IsDefined(evt.objectRecord) {
  // End DisableRevealPositionHack code
    player.QueueEvent(evt);
    hackingMinigameBB = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().HackingMinigame);
    hackingMinigameBB.SetVector4(GetAllBlackboardDefs().HackingMinigame.LastPlayerHackPosition, player.GetWorldPosition());
    return true;
  };
  return false;
}