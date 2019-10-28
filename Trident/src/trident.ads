-- SET10112 2018-9 TR2 001 - Formal Approaches to Software Engineering
-- Trident - Submarine Coursework
-- Version 0.3.1
-- Alexander Barker
-- 40333139
-- Last Updated on 19th April 2019
-- trident.ads

package Trident with SPARK_Mode is

   type Operational is (Yes, No);
   type WeaponsSystemAvailable is (Available, Unavailable);
   type TorpedoesStored is (Stored, Notstored);
   type TorpedoesLoaded is (Loaded, Notloaded);
   type TorpedoesFiring is (Firing, Waiting);
   type TorpedoesCount is range 0..5;
   type AirlockDoorOne is (Closed, Open);
   type AirlockDoorTwo is (Closed, Open);
   type AirlockLockOne is (Locked, Unlocked);
   type AirlockLockTwo is (Locked, Unlocked);
   type DiveOperation is (Dive, Surface);
   type DepthWarning is (OptimalDepth, Warning, MaximumDepth);
   type Depth is new Integer range 0..1000;
   type LifeSupport is (Optimal, Danger);
   type LifeSupportWarning is (OptimalOxygen, OxygenWarning);
   type OxygenPercentage is new Integer range 0..100;
   type ReactorWarning is (Optimal, Overheating);
   type ReactorTemp is range 0..250;

   type Submarine is record
      operating : Operational;
      WeaponsAvailablity : WeaponsSystemAvailable;
      CloseAirlockOne : AirlockDoorOne;
      CloseAirlockTwo : AirlockDoorTwo;
      LockAirlockOne : AirlockLockOne;
      LockAirlockTwo : AirlockLockTwo;
      torpedoes : TorpedoesCount;
      loaded : Boolean;
      storedTorpedoes : TorpedoesStored;
      loadedTorpedoes : TorpedoesLoaded;
      firingTorpedoes : TorpedoesFiring;
      diveOperational : DiveOperation;
      depthPositionCheck : DepthWarning;
      depthRange : Depth;
      lifeSupportStatus : LifeSupport;
      lifeSupportWarnings : LifeSupportWarning;
      oxygenRange : OxygenPercentage;
      reactorWarnings : ReactorWarning;
      reactorTemperature : ReactorTemp;
   end record;

   TridentSubmarine : Submarine := (operating => No, CloseAirlockOne => Open,
                                    CloseAirlockTwo => Closed, LockAirlockOne => Unlocked,
                                    LockAirlockTwo => Unlocked, WeaponsAvailablity => Unavailable,
                                    loaded => False, torpedoes => 0, storedTorpedoes => Notstored,
                                    loadedTorpedoes => NotLoaded, firingTorpedoes => Waiting,
                                    diveOperational => Surface, depthPositionCheck => OptimalDepth, depthRange => 0,
                                    lifeSupportStatus => Optimal, lifeSupportWarnings => OptimalOxygen, oxygenRange => 100,
                                    reactorTemperature => 1, reactorWarnings => Optimal);

   procedure OperateSubmarine with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.operating = No and then TridentSubmarine.CloseAirlockOne = Closed
     and then TridentSubmarine.LockAirlockOne = Locked and then TridentSubmarine.CloseAirlockTwo = Closed
     and then TridentSubmarine.LockAirlockTwo = Locked,
     Post => TridentSubmarine.operating = Yes;

   procedure WeaponsSystemCheck with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.operating = Yes and then TridentSubmarine.loadedTorpedoes = Loaded,
     Post => TridentSubmarine.WeaponsAvailablity = Available;

   procedure ReadyToFire with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.WeaponsAvailablity = Available and then TridentSubmarine.loadedTorpedoes = Loaded,
     Post => TridentSubmarine.WeaponsAvailablity = Available;

   procedure DepthPosition with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available,
     Post => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available;

   procedure DepthTest with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available and then
     TridentSubmarine.diveOperational = Dive and then
     TridentSubmarine.depthRange < 8,
     Post => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available and then
     TridentSubmarine.diveOperational = Dive and then
     TridentSubmarine.depthRange /= 0;

   procedure DiveCheck with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available and then
     TridentSubmarine.diveOperational = Surface,
     Post => TridentSubmarine.diveOperational = Dive;

   procedure EmergencySurface with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available and then
     TridentSubmarine.diveOperational = Dive,
     Post=> TridentSubmarine.diveOperational = Surface and then
     TridentSubmarine.oxygenRange = 100;

   procedure LifeSupportCheck with
     Global =>  (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available and then
     TridentSubmarine.oxygenRange <= 0,
     Post => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available and then
     TridentSubmarine.oxygenRange <= 0;

   procedure OxygenTest with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available and then
     TridentSubmarine.diveOperational = Dive and then
     TridentSubmarine.oxygenRange >= 20,
     Post => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available and then
     TridentSubmarine.diveOperational = Dive and then
     TridentSubmarine.oxygenRange >= 0;

   procedure ReactorCheck with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.WeaponsAvailablity = Available and then
     TridentSubmarine.reactorWarnings = Optimal and then
     TridentSubmarine.diveOperational = Dive,
     Post => TridentSubmarine.Operating = Yes and then
     TridentSubmarine.reactorWarnings = Optimal and then
     TridentSubmarine.reactorWarnings = Overheating;

   procedure Load with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.WeaponsAvailablity = Available and then TridentSubmarine.loaded = False and then TridentSubmarine.torpedoes > 0,
     Post => TridentSubmarine.loaded = True and then TridentSubmarine.loadedTorpedoes = Loaded and then TridentSubmarine.torpedoes = TridentSubmarine.torpedoes'Old;

   procedure Fire with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.WeaponsAvailablity = Available and then TridentSubmarine.loaded = True and then TridentSubmarine.torpedoes > 0,
     Post => TridentSubmarine.loaded = False and then TridentSubmarine.firingTorpedoes = Firing and then TridentSubmarine.torpedoes = TridentSubmarine.torpedoes'Old - 1;

   procedure Store  with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.WeaponsAvailablity = Available and then TridentSubmarine.torpedoes < TorpedoesCount'Last,
     Post => TridentSubmarine.torpedoes = TridentSubmarine.torpedoes'Old + 1 and then TridentSubmarine.storedTorpedoes = Stored;

   procedure CloseAirlockOne with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.CloseAirlockOne = Open and then TridentSubmarine.CloseAirlockTwo = Closed,
     Post => TridentSubmarine.CloseAirlockOne = Closed;

   procedure CloseAirlockTwo with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.CloseAirlockTwo = Open and then TridentSubmarine.CloseAirlockOne = Closed,
     Post => TridentSubmarine.CloseAirlockTwo = Closed;

   procedure LockAirlockOne with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.CloseAirlockOne = Closed and then
     TridentSubmarine.LockAirlockOne = Unlocked,
     Post => TridentSubmarine.LockAirlockOne = Locked;

   procedure LockAirlockTwo with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.CloseAirlockTwo = Closed and then
     TridentSubmarine.LockAirlockTwo = Unlocked,
     Post => TridentSubmarine.LockAirlockTwo = Locked;

   procedure OpenAirlockOne with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.LockAirlockOne = Unlocked and then
     TridentSubmarine.CloseAirlockOne = Closed and then
     TridentSubmarine.CloseAirlockTwo = Closed,
     Post => TridentSubmarine.CloseAirlockOne = Open;

   procedure OpenAirlockTwo with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.LockAirlockTwo = Unlocked and then
     TridentSubmarine.CloseAirlockTwo = Closed and then
     TridentSubmarine.CloseAirlockOne = Closed,
     Post => TridentSubmarine.CloseAirlockTwo = Open;

   procedure UnlockAirlockOne with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.CloseAirlockOne = Closed and then TridentSubmarine.LockAirlockOne = Locked,
     Post => TridentSubmarine.CloseAirlockOne = Closed and then TridentSubmarine.LockAirlockOne = Unlocked;

   procedure UnlockAirlockTwo with
     Global => (In_Out => TridentSubmarine),
     Pre => TridentSubmarine.CloseAirlockTwo = Closed and then TridentSubmarine.LockAirlockTwo = Locked,
     Post => TridentSubmarine.CloseAirlockTwo = Closed and then TridentSubmarine.LockAirlockTwo = Unlocked;

end Trident;
