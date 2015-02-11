/* Impose an ordering on the State. */
open util/ordering[elevatorState]
open util/ordering[doorState]
open util/ordering[buttonState]
open util/ordering[buttonLightState]
open util/ordering[directionState]

// An elevator system object in the elevator system

sig elevatorState { 
	firstLevel, secondLevel, thirdLevel: one ESObject 
}

sig doorState { 
	opened, closed: one Door 
}

sig buttonState { 
	on, off: one Button 
}

sig buttonLightState { 
	lightOn, lightOff: one Light 
}

sig directionState { 
	up, down, steady: one Directions 
}

sig Boolean {}

sig Button {
	takes: one Levels,
	opens: one Door,
	on:	Boolean, 
	off:	Boolean,
	lits: one Light
}

sig onButtonsList {
	onButtons: set Button
}

sig onLightsList {
	onLights: set Light
}

sig Light {
	on:	Boolean, 
	off:	Boolean 
}

sig Directions {
	up:	Boolean,
	down:	Boolean 
}

//TODO:: sig Timer {}

sig Door {
	opened:	Boolean,
	closed:	Boolean
	//TODO:: openTimer: one Timer
}

abstract sig Levels {
	door: one Door	
}

sig firstLevel extends Levels {
	firstUpButton: one Button,
	firstUpButtonLight: one Light	
}

sig secondLevel extends Levels {
	secondUpButton: one Button,
	secondDownButton: one Button,
	secondUpButtonLight: one Light,
	secondDownButtonLight: one Light		
}

sig thirdLevel extends Levels {
	thirdDownButton: one Button,
	thirdDownButtonLight: one Light
}

sig ESObject { 
	firstButton: one Button,
	secondButton: one Button,
	thirdButton: one Button,
	openDoorButton: one Button,
	closeDoorButton: one Button, 
	firstButtonLight: one Light,
	secondButtonLight: one Light,
	thirdButtonLight: one Light,
	openDoorButtonLight: one Light,
	closeDoorButtonLight: one Light,
	direction: one Directions,
	elevatorDoor: one Door,
	buttonsOn: one onButtonsList,
	lightsOn: one onLightsList,
	currentLevel: one Levels
}

// facts
fact { first.firstLevel = ESObject && no first.secondLevel && no first.thirdLevel }
fact { first.closed = ESObject.elevatorDoor && no first.opened }
fact { first.steady = ESObject.direction && no first.up && no first.down }

fact {ESObject.buttonsOn.onButtons = ESObject.firstButton + ESObject.secondButton}
fact {ESObject.lightsOn.onLights = ESObject.firstButtonLight + ESObject.secondButtonLight}

fact { ESObject.firstButton.takes = firstLevel && ESObject.secondButton.takes = secondLevel &&
		ESObject.thirdButton.takes = thirdLevel && firstLevel.firstUpButton.takes = firstLevel &&
		secondLevel.secondUpButton.takes = secondLevel && secondLevel.secondDownButton.takes = secondLevel &&
		thirdLevel.thirdDownButton.takes = thirdLevel }

fact { ESObject.firstButton.lits = ESObject.firstButtonLight && ESObject.secondButton.lits = ESObject.secondButtonLight &&
		ESObject.thirdButton.lits = ESObject.thirdButtonLight && ESObject.openDoorButton.lits = ESObject.openDoorButtonLight && 
		ESObject.closeDoorButton.lits = ESObject.closeDoorButtonLight &&
		firstLevel.firstUpButton.lits = firstLevel.firstUpButtonLight && secondLevel.secondUpButton.lits = secondLevel.secondUpButtonLight && 
		secondLevel.secondDownButton.lits = secondLevel.secondDownButtonLight &&	thirdLevel.thirdDownButton.lits = thirdLevel.thirdDownButtonLight }

fact { ESObject.firstButton.opens = ESObject.elevatorDoor && ESObject.secondButton.opens = ESObject.elevatorDoor &&
		ESObject.thirdButton.opens = ESObject.elevatorDoor && ESObject.openDoorButton.opens = ESObject.elevatorDoor && 
		ESObject.closeDoorButton.opens = ESObject.elevatorDoor &&
		firstLevel.firstUpButton.opens = ESObject.elevatorDoor && secondLevel.secondUpButton.opens = ESObject.elevatorDoor && 
		secondLevel.secondDownButton.opens = ESObject.elevatorDoor &&	thirdLevel.thirdDownButton.opens = ESObject.elevatorDoor }

/* At most one item to move from 'from' to 'to' */
pred moveElevator [from, from', to, to': one ESObject] {
  one x: from | {
    from' = from - x
    to' = to + x
  }
}

pred openDoor [on, on', off, off': one Door] {
  one x: on | {
    on' = on - x
    off' = off + x
  }
}

pred changeDirection [prev, prev', curr, curr': one Directions] {
  one x: prev | {
    prev' = prev - x
    curr' = curr + x
  }
}

fact {
     all s: elevatorState, s': s.next | all d: doorState {
       	(ESObject in s.firstLevel) && ((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons))=>
         	moveElevator [s.firstLevel, s'.firstLevel, s.firstLevel, s'.firstLevel]
       	else (ESObject in s.secondLevel) && ((ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons))=>
         	moveElevator [s.secondLevel, s'.secondLevel, s.secondLevel, s'.secondLevel]
	   	else (ESObject in s.thirdLevel) && ((ESObject.thirdButton  in ESObject.buttonsOn.onButtons) || (thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons))=>
			moveElevator [s.thirdLevel, s'.thirdLevel, s.thirdLevel, s'.thirdLevel]		
		else (ESObject in s.firstLevel) && (!(ESObject.firstButton in ESObject.buttonsOn.onButtons) && !(firstLevel.firstUpButton in ESObject.buttonsOn.onButtons)) && 
				((ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons))
				&& (ESObject.elevatorDoor in d.closed)=>
         	moveElevator [s.firstLevel, s'.firstLevel, s.secondLevel, s'.secondLevel]
		else (ESObject in s.firstLevel) && (!(ESObject.firstButton in ESObject.buttonsOn.onButtons) && !(firstLevel.firstUpButton in ESObject.buttonsOn.onButtons)) && 
				((ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons))
				&& (ESObject.elevatorDoor in d.opened)=>
         	moveElevator [s.firstLevel, s'.firstLevel, s.firstLevel, s'.firstLevel]
		else (ESObject in s.firstLevel) && (!(ESObject.firstButton in ESObject.buttonsOn.onButtons) && !(firstLevel.firstUpButton in ESObject.buttonsOn.onButtons)) &&
				(!(ESObject.secondButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.thirdButton  in ESObject.buttonsOn.onButtons) || (thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons))
				&& (ESObject.elevatorDoor in d.closed)=>
 			moveElevator [s.firstLevel, s'.firstLevel, s.thirdLevel, s'.thirdLevel]
		else (ESObject in s.firstLevel) && (!(ESObject.firstButton in ESObject.buttonsOn.onButtons) && !(firstLevel.firstUpButton in ESObject.buttonsOn.onButtons)) &&
				(!(ESObject.secondButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.thirdButton  in ESObject.buttonsOn.onButtons) || (thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons))
				&& (ESObject.elevatorDoor in d.opened)=>
 			moveElevator [s.firstLevel, s'.firstLevel, s.firstLevel, s'.firstLevel]
		else (ESObject in s.secondLevel) && (!(ESObject.secondButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
				(!(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) && !(thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) && //TODO: direction = down
				((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons))
				&& (ESObject.elevatorDoor in d.closed)=>
         	moveElevator [s.secondLevel, s'.secondLevel, s.firstLevel, s'.firstLevel]
		else (ESObject in s.secondLevel) && (!(ESObject.secondButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
				(!(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) && !(thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) && //TODO: direction = down
				((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons))
				&& (ESObject.elevatorDoor in d.opened)=>
         	moveElevator [s.secondLevel, s'.secondLevel, s.secondLevel, s'.secondLevel]
		else (ESObject in s.secondLevel) && (!(ESObject.secondButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.thirdButton  in ESObject.buttonsOn.onButtons) || (thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) //TODO: direction = up
				&& (ESObject.elevatorDoor in d.closed)=>
         	moveElevator [s.secondLevel, s'.secondLevel, s.thirdLevel, s'.thirdLevel]
		else (ESObject in s.thirdLevel) && (!(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) && !(thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) &&
				(!(ESObject.secondButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons))
				&& (ESObject.elevatorDoor in d.closed)=>
			moveElevator [s.thirdLevel, s'.thirdLevel, s.firstLevel, s'.firstLevel]
		else (ESObject in s.thirdLevel) && (!(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) && !(thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) &&
				(!(ESObject.secondButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons))
				&& (ESObject.elevatorDoor in d.opened)=>
			moveElevator [s.thirdLevel, s'.thirdLevel, s.thirdLevel, s'.thirdLevel]
		else (ESObject in s.thirdLevel) && (!(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) && !(thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons))
				&& (ESObject.elevatorDoor in d.closed)=>
			moveElevator [s.thirdLevel, s'.thirdLevel, s.secondLevel, s'.secondLevel]
		else (ESObject in s.thirdLevel) && (!(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) && !(thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons))
				&& (ESObject.elevatorDoor in d.opened)=>
			moveElevator [s.thirdLevel, s'.thirdLevel, s.thirdLevel, s'.thirdLevel]
     }
}

fact {
	all d: doorState, d': d.next | all s: elevatorState, s': s.next {
		(ESObject in s.firstLevel) && ((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons)) &&
		(ESObject.elevatorDoor in d.opened)=>
         	openDoor [d.opened, d'.opened, d.opened, d'.opened]
		else (ESObject in s.firstLevel) && ((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons)) &&
				(ESObject.elevatorDoor in d.closed)=>
         	openDoor [d.closed, d'.closed, d.opened, d'.opened]
       	else (ESObject in s.secondLevel) && ((ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
         		(ESObject.elevatorDoor in d.opened)=>
         	openDoor [d.opened, d'.opened, d.opened, d'.opened]
       	else (ESObject in s.secondLevel) && ((ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
         		(ESObject.elevatorDoor in d.closed)=>
         	openDoor [d.closed, d'.closed, d.opened, d'.opened]
	   	else (ESObject in s.thirdLevel) && ((ESObject.thirdButton  in ESObject.buttonsOn.onButtons) || (thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) &&
				(ESObject.elevatorDoor in d.opened)=>
         	openDoor [d.opened, d'.opened, d.opened, d'.opened]
	   	else (ESObject in s.thirdLevel) && ((ESObject.thirdButton  in ESObject.buttonsOn.onButtons) || (thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) &&
				(ESObject.elevatorDoor in d.closed)=>
         	openDoor [d.closed, d'.closed, d.opened, d'.opened]
		else (ESObject in s.firstLevel) && (!(ESObject.firstButton in ESObject.buttonsOn.onButtons) && !(firstLevel.firstUpButton in ESObject.buttonsOn.onButtons)) && 
				((ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons) ||
				(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) || (thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) &&
				(ESObject.elevatorDoor in d.opened)=>
 			openDoor [ d.opened, d'.opened, d.closed, d'.closed]
		else (ESObject in s.firstLevel) && (!(ESObject.firstButton in ESObject.buttonsOn.onButtons) && !(firstLevel.firstUpButton in ESObject.buttonsOn.onButtons)) && 
				((ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons) ||
				(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) || (thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) &&
				(ESObject.elevatorDoor in d.closed)=>
 			openDoor [ d.closed, d'.closed, d.closed, d'.closed]
		else (ESObject in s.secondLevel) && (!(ESObject.secondButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons) ||
				(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) || (thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) && //TODO: direction = up
         		(ESObject.elevatorDoor in d.opened)=>
 			openDoor [ d.opened, d'.opened, d.closed, d'.closed]
		else (ESObject in s.secondLevel) && (!(ESObject.secondButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) && !(secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons) ||
				(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) || (thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) && //TODO: direction = up
				(ESObject.elevatorDoor in d.closed)=>
 			openDoor [ d.closed, d'.closed, d.closed, d'.closed]
		else (ESObject in s.thirdLevel) && (!(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) && !(thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons) ||
				(ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
         		(ESObject.elevatorDoor in d.opened)=>
 			openDoor [ d.opened, d'.opened, d.closed, d'.closed]
		else (ESObject in s.thirdLevel) && (!(ESObject.thirdButton  in ESObject.buttonsOn.onButtons) && !(thirdLevel.thirdDownButton in ESObject.buttonsOn.onButtons)) &&
				((ESObject.firstButton in ESObject.buttonsOn.onButtons) || (firstLevel.firstUpButton in ESObject.buttonsOn.onButtons) ||
				(ESObject.secondButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondUpButton in ESObject.buttonsOn.onButtons) || (secondLevel.secondDownButton in ESObject.buttonsOn.onButtons)) &&
				(ESObject.elevatorDoor in d.closed)=>
 			openDoor [ d.closed, d'.closed, d.closed, d'.closed]
	}
}


assert checkButtonExist {no e: ESObject | all b: Button | e.firstButton != b}
check checkButtonExist for 5

assert checkAnyLightsOn {no e: ESObject | one b: Button | (b in e.buttonsOn.onButtons) && !(b.lits in e.lightsOn.onLights)}
check checkAnyLightsOn for 5

assert checkLightsOn {no e: ESObject | (e.firstButton in e.buttonsOn.onButtons) && !(e.firstButtonLight in e.lightsOn.onLights)}
check checkLightsOn for 5

assert checkDoorOpen {no e: ESObject | all s: elevatorState | all d: doorState | (ESObject in s.firstLevel) && (e.firstButton in e.buttonsOn.onButtons) && (e.elevatorDoor in d.closed)}
check checkDoorOpen for 5
