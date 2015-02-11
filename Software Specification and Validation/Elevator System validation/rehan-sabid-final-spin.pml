bool doorOpen = false ;
bool openDoorButton =false ;
bool closeDoorButton = false ;
bool firstButton = false ;
bool secondButton = false ;
bool thirdButton = false;
bool firstUpButton = false;
bool secondUpButton = false;
bool secondDownButton = false;
bool thirdDownButton = false;
bool openDoorButtonLight = false;
bool closeDoorButtonLight = false;
bool firstButtonLight = false;
bool secondButtonLight = false;
bool thirdButtonLight = false;
bool firstUpButtonLight = false;
bool secondUpButtonLight = false;
bool secondDownButtonLight = false;
bool thirdDownButtonLight = false;

byte elevatorLevel = 1;
byte direction = 2; // 1=down, 2=steady, 3=up
int remainedAsOpen = 0;
int doorOpenTimer 	= 5;
bool	doorIsOpen;	//		:= ((doorOpenTimer - remainedAsOpen) < 5) & ((doorOpenTimer - remainedAsOpen) >= 0);
bool doorCanClose; //		:= ((remainedAsOpen - doorOpenTimer) = 1);


proctype defineS(){
			do 
			:: 
				if :: ((doorOpenTimer - remainedAsOpen) < 5) && ((doorOpenTimer - remainedAsOpen) > 1) == true -> doorIsOpen = true
                   :: ((remainedAsOpen - doorOpenTimer) == 1) == true -> doorCanClose = true
				   :: (((doorOpenTimer - remainedAsOpen) < 5) && ((doorOpenTimer - remainedAsOpen) > 1)) == false -> doorIsOpen = false
                   :: ((remainedAsOpen - doorOpenTimer) == 1) == false -> doorCanClose = false
				   
				   :: else -> skip;
				fi
				
			od

}

//--open/close has higher priority
proctype remainedAsOpenS(){
			do 
			:: 
				if :: doorOpen == true && remainedAsOpen == 0	-> remainedAsOpen = remainedAsOpen + 1;
				   ::	doorOpen == true && (doorIsOpen == true) -> remainedAsOpen = remainedAsOpen + 1;
				   ::	doorOpen == true && (doorCanClose == true)	-> remainedAsOpen = remainedAsOpen - remainedAsOpen; //0;
					:: elevatorLevel == 1 && (firstButton == true || firstUpButton == true)	-> remainedAsOpen = remainedAsOpen - remainedAsOpen;// 0	--whenever the gate is open, 5 time unit is added
					::	elevatorLevel == 1 && (firstButton == false && firstUpButton == false) && doorOpen == false && (secondButton == true || secondUpButton == true || secondDownButton == true || thirdButton == true || thirdDownButton == true)	-> remainedAsOpen = remainedAsOpen - remainedAsOpen;// 0;
					::	elevatorLevel == 1 && (firstButton == false && firstUpButton == false) && doorOpen == true && (doorIsOpen == true)	&& (secondButton == true || secondUpButton == true || secondDownButton == true || thirdButton == true || thirdDownButton == true) -> remainedAsOpen =remainedAsOpen + 1;
					:: elevatorLevel == 1 && (firstButton == false && firstUpButton == false) && doorOpen == true && (doorCanClose == true) ->  remainedAsOpen = remainedAsOpen - remainedAsOpen;//0;
					:: elevatorLevel == 2 && (secondButton == true || secondUpButton == true || secondDownButton == true)	->  remainedAsOpen =  0;
					:: elevatorLevel == 2 && (secondButton == false && secondUpButton == false && secondDownButton == false) && doorOpen == false && (firstButton == true || firstUpButton == true || thirdButton == true || thirdDownButton == true)	->  remainedAsOpen = 0;
					:: elevatorLevel == 2 && (secondButton == false && secondUpButton == false && secondDownButton == false) && doorOpen == true && (doorIsOpen == true) && (firstButton == true || firstUpButton == true || thirdButton == true || thirdDownButton == true) ->  remainedAsOpen = remainedAsOpen + 1;
					::	elevatorLevel == 2 && (secondButton == false && secondUpButton == false && secondDownButton == false) && doorOpen == true && (doorCanClose == true) ->  remainedAsOpen = 0;
					:: elevatorLevel == 3 && (thirdButton == true || thirdDownButton == true)	->  remainedAsOpen = 0;
					::	elevatorLevel == 3 && (thirdButton == false && thirdDownButton == false) && doorOpen == false && (firstButton == true || firstUpButton == true || secondButton == true || secondUpButton == true || secondDownButton == true)	->  remainedAsOpen = 0;
					::	elevatorLevel == 3 && (thirdButton == false && thirdDownButton == false) && doorOpen == true && (doorIsOpen == true) && (secondButton == true || secondUpButton == true || secondDownButton == true || thirdButton == true || thirdDownButton == true) ->  remainedAsOpen = remainedAsOpen + 1;
					::	elevatorLevel == 3 && (thirdButton == false && thirdDownButton == false) && doorOpen == true && (doorCanClose == true) ->  remainedAsOpen = 0;
					::(elevatorLevel == 1 || elevatorLevel == 2 || elevatorLevel == 3) & openDoorButton == true	->  remainedAsOpen = 0;
					::	(elevatorLevel == 1 || elevatorLevel == 2 || elevatorLevel == 3) && closeDoorButton == true && (doorIsOpen == true)	->  remainedAsOpen = remainedAsOpen + 1;
					::	(elevatorLevel == 1 || elevatorLevel == 2 || elevatorLevel == 3) && closeDoorButton == true && doorOpen == true && (doorCanClose == true)	->  remainedAsOpen = 0;
											
				   :: else -> skip;
				fi
				
			od

}
//assumptions: 	openDoorButton/closeDoorButton has higher priority than others; current floor's buttons are served first; 
	
proctype doorOpenS(){
			do 
			:: 
				if :: ((doorOpenTimer - remainedAsOpen) < 5) && ((doorOpenTimer - remainedAsOpen) > 1) == true -> doorIsOpen = true
				   :: (doorIsOpen == true)	-> doorOpen = true;
				   :: (doorCanClose == true) -> doorOpen = true;
				   :: elevatorLevel == 1 && (firstButton == true || firstUpButton == true)	-> doorOpen = true;
				   :: elevatorLevel == 1 && (firstButton == false && firstUpButton == false) && doorOpen == false && (secondButton == true || secondUpButton == true || secondDownButton == true || thirdButton == true || thirdDownButton == true)	-> doorOpen = false;
				   :: elevatorLevel == 1 && (firstButton == false && firstUpButton == false) && doorOpen == true && (doorIsOpen == true) && (secondButton == true || secondUpButton == true || secondDownButton == true || thirdButton == true || thirdDownButton == true) -> doorOpen = true;
					:: elevatorLevel == 1 && (firstButton == false && firstUpButton == false) && doorOpen == true && (doorCanClose == true) -> doorOpen = false;
				
					:: elevatorLevel == 2 && (secondButton == true || secondUpButton == true || secondDownButton == true)	-> doorOpen = true;
					::	elevatorLevel == 2 && (secondButton == false && secondUpButton == false && secondDownButton == false) && doorOpen == false && (firstButton == true || firstUpButton == true || thirdButton == true || thirdDownButton == true)	-> doorOpen = false;
					::	elevatorLevel == 2 && (secondButton == false && secondUpButton == false && secondDownButton == false) && doorOpen == true && (doorIsOpen == true) && (firstButton == true || firstUpButton == true || thirdButton == true || thirdDownButton == true) -> doorOpen = true;
					::	elevatorLevel == 2 && (secondButton == false && secondUpButton == false && secondDownButton == false) && doorOpen == true && (doorCanClose == true) -> doorOpen = false;
					:: elevatorLevel == 3 && (thirdButton == true || thirdDownButton == true)	-> elevatorLevel = true;
					::	elevatorLevel == 3 && (thirdButton == false && thirdDownButton == false) && doorOpen == false && (firstButton == true || firstUpButton == true || secondButton == true || secondUpButton == true || secondDownButton == true)	-> doorOpen = false;
					::	elevatorLevel == 3 && (thirdButton == false && thirdDownButton == false) && doorOpen == true && (doorIsOpen == true) && (secondButton == true || secondUpButton == true || secondDownButton == true || thirdButton == true || thirdDownButton == true) -> doorOpen = true;
					::	elevatorLevel == 3 && (thirdButton == false && thirdDownButton == false) && doorOpen == true && (doorCanClose == true) -> doorOpen = false;
					::	(elevatorLevel == 1 || elevatorLevel == 2 || elevatorLevel == 3) && openDoorButton == true	-> doorOpen = true;
					::	(elevatorLevel == 1 || elevatorLevel == 2 || elevatorLevel == 3) && closeDoorButton == true && (doorIsOpen == true)	-> doorOpen = true;
					::	(elevatorLevel == 1 || elevatorLevel == 2 || elevatorLevel == 3) && closeDoorButton == true && doorOpen == true && (doorCanClose == true)	-> doorOpen = false;
				   
				   :: else -> skip;
				fi
				
			od

}

proctype elevatorS(){
			do 
			:: 
				if :: elevatorLevel == 1 && (firstButton == true || firstUpButton == true)	-> elevatorLevel = 1;
				   :: elevatorLevel == 1 && (firstButton == false && firstUpButton == false) && (secondButton == true || secondUpButton == true || secondDownButton == true) && doorOpen == false -> elevatorLevel = 2 ;
				   :: elevatorLevel == 1 && (firstButton == false && firstUpButton == false) && thirdButton == true && (secondButton == false && secondUpButton == false && secondDownButton == false) && doorOpen == false 	-> elevatorLevel = 3;
				   ::	elevatorLevel == 2 && (secondButton == true || secondUpButton == true || secondDownButton == true)	-> elevatorLevel = 2;
					::	elevatorLevel == 2 && (secondButton == false && secondUpButton == false && secondDownButton == false) && (firstButton == true || firstUpButton == true) && (thirdButton == false && thirdDownButton == false) && doorOpen == false	-> elevatorLevel = 1;
					::	elevatorLevel == 2 && (secondButton == false && secondUpButton == false && secondDownButton == false) && (thirdButton == true || thirdDownButton == true) && doorOpen == false	-> elevatorLevel = 3;
					::	elevatorLevel == 3 && (thirdButton == true || thirdDownButton == true)	-> elevatorLevel = 3;						
					::	elevatorLevel == 3 && (thirdButton == false && thirdDownButton == false) && (firstButton == true || firstUpButton == true) && (secondButton == false && secondUpButton == false && secondDownButton == false) && doorOpen == false	-> elevatorLevel = 1;
					::	elevatorLevel == 3 && (thirdButton == false && thirdDownButton == false) && (secondButton == true || secondUpButton == true || secondDownButton == true) && doorOpen == false	-> elevatorLevel = 2;
							
				   :: else -> skip;
				fi
				
			od

}

proctype directionS(){
			do 
			:: 
				if :: elevatorLevel == 1  && (firstButton == false && firstUpButton == false) && (secondButton == true || secondUpButton == true || secondDownButton == true | 
							thirdButton == true || thirdDownButton == true) && doorOpen == false -> direction = 3;
		           :: elevatorLevel == 1  && (firstButton == false && firstUpButton == false) && (secondButton == true || secondUpButton == true || secondDownButton == true | 
							thirdButton == true || thirdDownButton == true) && doorOpen == false -> direction = 3;
		           :: elevatorLevel == 2 && (secondButton ==false && secondUpButton == false && secondDownButton == false) && 
							(firstButton == true || firstUpButton == true) && (thirdButton == false && thirdDownButton == false) && doorOpen == false	-> direction = 1;
				   :: elevatorLevel == 2 && (secondButton == false && secondUpButton == false && secondDownButton == false) && 
							(thirdButton == true || thirdDownButton == true) && doorOpen == false	-> direction = 3;								
				   :: elevatorLevel == 3 && (thirdButton == false && thirdDownButton == false) && (firstButton == true || firstUpButton == true || secondButton == true || 
							secondUpButton == true || secondDownButton == true) && doorOpen == false -> direction = 1;
				   :: elevatorLevel == 1 && (firstButton == true || firstUpButton == true)	-> direction = 2;
				   :: elevatorLevel == 1 && (secondButton == false && secondUpButton == false && secondDownButton == false && thirdButton == false && thirdDownButton == false)	-> direction = 2;
				   :: elevatorLevel == 2 && (secondButton == true || secondUpButton == true || secondDownButton == true)	-> direction = 2;
				   :: elevatorLevel == 2 && (firstButton == false && firstUpButton == false && thirdButton == false && thirdDownButton == false)	-> direction = 2;
				   :: elevatorLevel == 3 && (thirdButton == true || thirdDownButton == true)	-> direction = 2;
				   :: elevatorLevel == 3 && (firstButton == false && firstUpButton == false && secondButton == false && secondUpButton == false && secondDownButton == false)	-> direction = 2;
							
				   :: else -> skip;
				fi
				
			od

}

proctype buttonS(){
				
			do 
			:: 
				if :: openDoorButton == true && doorOpen == true -> openDoorButton = false
				   :: closeDoorButton == true && doorOpen == false -> closeDoorButton = false
				   :: firstButton == true && elevatorLevel == 1 && doorOpen == true	-> firstButton = false;
				   :: secondButton == true && elevatorLevel == 2 && doorOpen == true	->	secondButton = false;
				   :: thirdButton == true && elevatorLevel == 3 && doorOpen == true -> thirdButton = false;
				   :: firstUpButton == true && elevatorLevel == 1 && doorOpen == true ->	firstUpButton = false;
				   :: secondUpButton == true && elevatorLevel == 2 && doorOpen == true -> secondUpButton = false;
				   :: secondDownButton == true && elevatorLevel == 2 && doorOpen == true -> secondDownButton = false;
				   :: thirdDownButton == true && elevatorLevel == 3 && doorOpen == true	->	thirdDownButton = false;								
							
				   :: else -> skip;
				fi
				
			od
}

proctype lightS(){
				
			do 
			:: 
				if :: openDoorButton == true && doorOpen == true -> openDoorButtonLight = false
				   :: openDoorButton -> openDoorButtonLight = true
				   :: closeDoorButton == true && doorOpen == false -> closeDoorButtonLight = false
				   :: closeDoorButton == true -> closeDoorButtonLight = true
				   :: firstButton == true && elevatorLevel == 1 && doorOpen == true	-> firstButtonLight = false 
				   :: firstButton == true -> firstButtonLight = true
				   :: secondButton == true && elevatorLevel == 2 && doorOpen == true	->	secondButtonLight = false;
				   :: secondButton == true -> secondButtonLight = true;
				   :: thirdButton == true && elevatorLevel == 3 && doorOpen == true -> thirdButtonLight = false;
				   :: thirdButton == true -> thirdButtonLight = true;
				   :: firstUpButton == true && elevatorLevel == 1 && doorOpen == true ->	firstUpButtonLight = false;
				   :: firstUpButton == true -> firstUpButtonLight = true
				   :: secondUpButton == true && elevatorLevel == 2 && doorOpen == true -> secondUpButtonLight = false;
				   :: secondUpButton == true -> secondUpButtonLight = true
				   :: secondDownButton == true && elevatorLevel == 2 && doorOpen == true -> secondDownButtonLight = false;
				   :: secondDownButton == true -> secondDownButtonLight = true
				   :: thirdDownButton == true && elevatorLevel == 3 && doorOpen == true	->	thirdDownButtonLight = false;								
				   :: thirdDownButton == true -> thirdDownButtonLight = true		
				   :: else -> skip;
				fi
				
			od
}



init
	{	 
		run buttonS(); run lightS(); run directionS(); run elevatorS(); run doorOpenS(); run remainedAsOpenS()
	}
//door always close when moving	
//ltl p1 { [] !((direction == 1 || direction == 3) && doorOpen)};
// reuqest to level 1 is eventually served
//ltl p2 { []  ( (firstButton == true || firstUpButton == true)   -> <>   (elevatorLevel==1 && doorOpen == true)  )}
// reuqest to level 2 is eventually served
ltl p3 { []  ( (secondButton == true || secondUpButton == true)   -> <>   (elevatorLevel==2 && doorOpen == true)  )}
// reuqest to level 3 is eventually served
//ltl p4 { []  ( (thirdButton == true || thirdDownButton == true)   -> <>   (elevatorLevel==3 && doorOpen == true)  )}

// door eventually closes
//ltl p5 { []((doorOpen== true) -> <> (doorOpen==false))}


