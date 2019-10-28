-- SET10112 2018-9 TR2 001 - Formal Approaches to Software Engineering
-- Trident - Submarine Coursework
-- Version 0.3.1
-- Alexander Barker
-- 40333139
-- Last Updated on 19th April 2019
-- trident.adb

with Ada.Text_IO; use Ada.Text_IO;
package body Trident with SPARK_Mode is

   procedure ReadyToFire is
   begin
      if TridentSubmarine.loaded and TridentSubmarine.torpedoes > 0 then TridentSubmarine.torpedoes := TridentSubmarine.torpedoes - 1;
         TridentSubmarine.loaded := True;
         TridentSubmarine.loadedTorpedoes := Loaded;
      else
         TridentSubmarine.loadedTorpedoes := Notloaded;
      end if;
   end ReadyToFire;

   procedure Load is
   begin
      if not TridentSubmarine.loaded and TridentSubmarine.torpedoes > 0 then TridentSubmarine.loaded := True;
         TridentSubmarine.loadedTorpedoes := Loaded;
      else
         TridentSubmarine.loadedTorpedoes := Notloaded;
         Ada.Text_IO.Put_Line("");
         Ada.Text_IO.Put_Line("       ***WARNING - Attempted Torpedo Loading Failure!***       ");
         Ada.Text_IO.Put_Line("");
      end if;
   end Load;

   procedure Fire is
   begin
      if TridentSubmarine.loaded and TridentSubmarine.torpedoes > 0 then TridentSubmarine.torpedoes := TridentSubmarine.torpedoes - 1;
         TridentSubmarine.loaded := False;
         TridentSubmarine.firingTorpedoes := Firing;
      else
         TridentSubmarine.firingTorpedoes := Waiting;
         Ada.Text_IO.Put_Line("");
         Ada.Text_IO.Put_Line("       ***WARNING - Attempted Torpedo Firing Failure!***       ");
         Ada.Text_IO.Put_Line("");
      end if;
   end Fire;

   procedure Store is
   begin
      if TridentSubmarine.torpedoes < TorpedoesCount'Last then TridentSubmarine.torpedoes := TridentSubmarine.torpedoes + 1;
         TridentSubmarine.storedTorpedoes := Stored;
      else
         TridentSubmarine.storedTorpedoes := Notstored;
         Ada.Text_IO.Put_Line("");
         Ada.Text_IO.Put_Line("       ***WARNING - Maximum Torpedo Capacity!***       ");
         Ada.Text_IO.Put_Line("");
      end if;
   end Store;

   procedure CloseAirlockOne is
   begin
       if (TridentSubmarine.CloseAirlockOne = Open and then TridentSubmarine.CloseAirlockTwo = Closed) then
         TridentSubmarine.CloseAirlockOne := Closed;
      end if;
   end CloseAirlockOne;

   procedure CloseAirlockTwo is
   begin
      if (TridentSubmarine.CloseAirlockTwo = Open and then TridentSubmarine.CloseAirlockOne = Closed) then
         TridentSubmarine.CloseAirlockTwo := Closed;
      end if;
   end CloseAirlockTwo;

   procedure LockAirlockOne is
   begin
      if (TridentSubmarine.CloseAirlockOne = Closed and then TridentSubmarine.LockAirlockOne = Unlocked) then
         TridentSubmarine.LockAirlockOne := Locked;
      end if;
   end LockAirlockOne;

   procedure LockAirlockTwo is
   begin
      if (TridentSubmarine.CloseAirlockTwo = Closed and then TridentSubmarine.LockAirlockTwo = Unlocked) then
         TridentSubmarine.LockAirlockTwo := Locked;
      end if;
   end LockAirlockTwo;

   procedure OpenAirlockOne is
   begin
      if (TridentSubmarine.LockAirlockOne = Unlocked and then TridentSubmarine.CloseAirlockOne = Closed and then
          TridentSubmarine.CloseAirlockTwo = Closed) then TridentSubmarine.CloseAirlockOne := Open;
      end if;
   end OpenAirlockOne;

   procedure OpenAirlockTwo is
   begin
      if (TridentSubmarine.LockAirlockTwo = Unlocked and then TridentSubmarine.CloseAirlockTwo = Closed and then
          TridentSubmarine.CloseAirlockOne = Closed) then TridentSubmarine.CloseAirlockTwo := Open;
      end if;
   end OpenAirlockTwo;

   procedure UnlockAirlockOne is
   begin
      if (TridentSubmarine.CloseAirlockOne = Closed and then TridentSubmarine.LockAirlockOne = Locked) then
         TridentSubmarine.LockAirlockOne := Unlocked;
      end if;
   end UnlockAirlockOne;

   procedure UnlockAirlockTwo is
   begin
      if (TridentSubmarine.CloseAirlockTwo = Closed and then TridentSubmarine.LockAirlockTwo = Locked) then
         TridentSubmarine.LockAirlockTwo := Unlocked;
      end if;
   end UnlockAirlockTwo;

   procedure OperateSubmarine is
   begin
      if (TridentSubmarine.operating = No and then TridentSubmarine.CloseAirlockOne = Closed and then
          TridentSubmarine.LockAirlockOne = Locked and then TridentSubmarine.CloseAirlockTwo = Closed and then
          TridentSubmarine.LockAirlockTwo = Locked) then TridentSubmarine.operating := Yes;
      else
         TridentSubmarine.operating := No;
      end if;
   end OperateSubmarine;

   procedure WeaponsSystemCheck is
   begin
      if (TridentSubmarine.operating = Yes) then TridentSubmarine.WeaponsAvailablity := Available;
      else
         TridentSubmarine.WeaponsAvailablity := Unavailable;
      end if;
   end WeaponsSystemCheck;

   procedure DepthPosition is
   begin
      if (TridentSubmarine.depthRange >= 0 and TridentSubmarine.depthRange < 900) then
        TridentSubmarine.depthPositionCheck := OptimalDepth;
      elsif (TridentSubmarine.depthRange >= 900 and TridentSubmarine.depthRange < 999) then
        TridentSubmarine.depthPositionCheck := Warning;
      else
         TridentSubmarine.depthPositionCheck := MaximumDepth;
      end if;
   end DepthPosition;

   procedure DepthTest is
   begin
      if (TridentSubmarine.Operating = Yes and then
          TridentSubmarine.WeaponsAvailablity = Available and then
          TridentSubmarine.diveOperational = Dive and then
          TridentSubmarine.depthRange < 900) then
         TridentSubmarine.depthRange := TridentSubmarine.depthRange + 250;
      elsif (TridentSubmarine.depthRange >=999) then
         TridentSubmarine.depthRange := TridentSubmarine.depthRange + 0;
      end if;
   end DepthTest;

   procedure DiveCheck is
   begin
      if (TridentSubmarine.Operating = Yes and then
          TridentSubmarine.WeaponsAvailablity = Available and then
          TridentSubmarine.diveOperational = Surface) then
         TridentSubmarine.diveOperational := Dive;
      else
         TridentSubmarine.diveOperational := Surface;
      end if;
   end DiveCheck;

   procedure EmergencySurface is
   begin
      if (TridentSubmarine.Operating = Yes and then
          TridentSubmarine.WeaponsAvailablity = Available and then
          TridentSubmarine.diveOperational = Dive) then
         TridentSubmarine.depthRange := 0;
         TridentSubmarine.diveOperational := Surface;
         TridentSubmarine.oxygenRange := 100;
      end if;
   end EmergencySurface;

   procedure LifeSupportCheck is
   begin
      if (TridentSubmarine.oxygenRange = 100 or TridentSubmarine.oxygenRange > 20) then
         TridentSubmarine.lifeSupportStatus := Optimal;
      elsif (TridentSubmarine.oxygenRange <= 20 and TridentSubmarine.oxygenRange >=1) then
         TridentSubmarine.lifeSupportStatus := Danger;
         TridentSubmarine.lifeSupportWarnings := OxygenWarning;
         Ada.Text_IO.Put_Line("");
         Ada.Text_IO.Put_Line("       ***WARNING - Oxygen Level Critical!***       ");
         Ada.Text_IO.Put_Line("");
      end if;
   end LifeSupportCheck;

   procedure OxygenTest is
   begin
      if (TridentSubmarine.Operating = Yes and then
          TridentSubmarine.WeaponsAvailablity = Available and then
          TridentSubmarine.diveOperational = Dive and then
          TridentSubmarine.oxygenRange >= 21) then
          TridentSubmarine.oxygenRange := TridentSubmarine.oxygenRange - 10;
      elsif (TridentSubmarine.oxygenRange <= 20 and TridentSubmarine.oxygenRange >= 10) then
         TridentSubmarine.oxygenRange := TridentSubmarine.oxygenRange - 10;
         TridentSubmarine.lifeSupportWarnings := OxygenWarning;
         Put_Line(TridentSubmarine.lifeSupportWarnings'Image);
      elsif (TridentSubmarine.oxygenRange < 1) then
         Put_Line(TridentSubmarine.lifeSupportWarnings'Image);
         Ada.Text_IO.Put_Line("");
         Ada.Text_IO.Put_Line("       ***WARNING - Emergency Resurface Required! (Life Support)***       ");
         Ada.Text_IO.Put_Line("");
         EmergencySurface;
         Put_Line(TridentSubmarine.diveOperational'Image);
         Ada.Text_IO.Put_Line("Emergency Resurface Completed");

      end if;
   end OxygenTest;

 procedure ReactorCheck is
   begin
      if (TridentSubmarine.Operating = Yes and then
          TridentSubmarine.WeaponsAvailablity = Available and then
          TridentSubmarine.reactorWarnings = Optimal and then
          TridentSubmarine.diveOperational = Dive) then
          TridentSubmarine.reactorWarnings := Overheating;
          Put("Reactor Temperature Status: ");
          Put_Line(TridentSubmarine.reactorWarnings'Image);
          Ada.Text_IO.Put_Line("");
          Ada.Text_IO.Put_Line("       ***WARNING - Emergency Resurface Required! (Reactor Overheating)***       ");
          Ada.Text_IO.Put_Line("");
          EmergencySurface;
          Put(TridentSubmarine.diveOperational'Image);
          Ada.Text_IO.Put_Line(" - Emergency Resurface Completed");
      end if;
   end ReactorCheck;


end Trident;
