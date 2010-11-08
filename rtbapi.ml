(***************************************************************************
   	                       _            _   _                 _
   	    ___ __ _ _ __ ___ | |      _ __| |_| |__   __ _ _ __ (_)
   	   / __/ _` | '_ ` _ \| |_____| '__| __| '_ \ / _` | '_ \| |
   	  | (_| (_| | | | | | | |_____| |  | |_| |_) | (_| | |_) | |
    	   \___\__,_|_| |_| |_|_|     |_|   \__|_.__/ \__,_| .__/|_|
  	                                                      |_|

                                                    by Keymon

   Copyright (C) 2003
            Hector Rivas Gandara (Keymon) <keymon/at/wanadoo.es>

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the
   Free Software Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.

 **************************************************************************)

(** What rotate *)
type rotate_type =
	RotateRobot | RotateCannon | RotateRadar;;

let int_of_rotate = function
	RotateRobot  -> 1
 | RotateCannon -> 2
 | RotateRadar  -> 4;;

let rec rotate_list_of_int i =
   if (i/4) > 0 then RotateRadar::(rotate_list_of_int (i mod 4))
   else if (i/2) > 0 then RotateCannon::(rotate_list_of_int (i mod 2))
   else if (i > 0) then [RotateRobot]
   else [];;

(** Warning message *)
type warning_type =
	UnknownMessage | ProcessTimeLow |
	MessageSentInIllegalState | UnknownOption |
	ObsoleteKeyword | NameNotGiven | ColourNotGiven  |
   UnknownWarning;;


let warning_of_int = function
   0 -> UnknownMessage
 | 1 -> ProcessTimeLow
 | 2 -> MessageSentInIllegalState
 | 3 -> UnknownOption
 | 4 -> ObsoleteKeyword
 | 5 -> NameNotGiven
 | 6 -> ColourNotGiven
 | _ -> UnknownWarning;;

(** Game options *)
type game_option_type =
   RobotMaxRotate | CannonMaxRotate | RadarMaxRotate |
   RobotMaxAcceleration | RobotMinAcceleration |
   RobotStartEnergy | RobotMaxEnergy | RobotEnergyLevels |
   ShotSpeed | ShotMinEnergy | ShotMaxEnergy | ShotEnergyIncreaseSpeed |
   Timeout | DebugLevel | SendRobotCoordinates | UnknownOption;;

let game_option_of_int = function
   0 -> RobotMaxRotate
 | 1 -> CannonMaxRotate
 | 2 -> RadarMaxRotate
 | 3 -> RobotMaxAcceleration
 | 4 -> RobotMinAcceleration
 | 5 -> RobotStartEnergy
 | 6 -> RobotMaxEnergy
 | 7 -> RobotEnergyLevels
 | 8 -> ShotSpeed
 | 9 -> ShotMinEnergy
 | 10 ->ShotMaxEnergy
 | 11 ->ShotEnergyIncreaseSpeed
 | 12 ->Timeout
 | 13 ->DebugLevel
 | 14 ->SendRobotCoordinates
 | _  ->UnknownOption ;;

let string_of_game_option = function
   RobotMaxRotate           -> "RobotMaxRotate"
 | CannonMaxRotate          -> "CannonMaxRotate"
 | RadarMaxRotate           -> "RadarMaxRotate"
 | RobotMaxAcceleration     -> "RobotMaxAcceleration"
 | RobotMinAcceleration     -> "RobotMinAcceleration"
 | RobotStartEnergy         -> "RobotStartEnergy"
 | RobotMaxEnergy           -> "RobotMaxEnergy"
 | RobotEnergyLevels        -> "RobotEnergyLevels"
 | ShotSpeed                -> "ShotSpeed"
 | ShotMinEnergy            -> "ShotMinEnergy"
 | ShotMaxEnergy            -> "ShotMaxEnergy"
 | ShotEnergyIncreaseSpeed  -> "ShotEnergyIncreaseSpeed"
 | Timeout                  -> "Timeout"
 | DebugLevel               -> "DebugLevel"
 | SendRobotCoordinates     -> "SendRobotCoordinates"
 | UnknownOption            -> "UnknownOption";;

(** Robot options *)
type robot_option_type =
   Signal | SendSignal | SendRotationReached | UseNonBlocking;;


let int_of_robot_option = function
   Signal -> 2
 | SendSignal -> 0
 | SendRotationReached -> 1
 | UseNonBlocking -> 3


(** Objects *)
type object_type =
   NoObject | Robot | Shot | Wall |	Cookie | Mine | LastObjectType;;

let object_of_int = function
   0 -> Robot
 | 1 -> Shot
 | 2 -> Wall
 |	3 -> Cookie
 | 4 -> Mine
 | 5 -> LastObjectType
 | _ -> NoObject;;

let string_of_object = function
   NoObject       -> "NoObject"
 | Robot          -> "Robot"
 | Shot           -> "Shot"
 | Wall           -> "Wall"
 |	Cookie         -> "Cookie"
 | Mine           -> "Mine"
 | LastObjectType -> "LastObjectType";;

(************************************************************************)

(*************************************************************************)
(*                  Game options control                                 *)
(*************************************************************************)
(** Game option list, with default values *)
let gameOptions =
	ref  [(RobotMaxRotate, 0.785398);
			(CannonMaxRotate, 1.5708);
			(RadarMaxRotate, 2.0944);
			(RobotMaxAcceleration, 2.);
			(RobotMinAcceleration, -0.5);
			(RobotStartEnergy, 100.);
			(RobotMaxEnergy, 120.);
			(RobotEnergyLevels, 10.);
			(ShotSpeed, 10.);
			(ShotMinEnergy, 0.5);
			(ShotMaxEnergy, 30.);
			(ShotEnergyIncreaseSpeed, 10.);
			(Timeout, 120.);
			(DebugLevel, 0.);
			(SendRobotCoordinates, 0.)];;

(**
	Set a game option in the option list
   @param option Option to set
   @param value Value of option
  *)
let setGameOption option value =
   gameOptions := (option,value)::(List.remove_assoc option !gameOptions);;


(**
	Return the value of a option
  *)
let getGameOption option =
	try
		List.assoc option !gameOptions
   with Not_found -> 0.;;

(************************************************************************)

(************************************)
(*   Messages from robots to server *)
(************************************)

(** Sends a message to server *)
let sendMessage msg =
   print_endline msg;
   flush stdout;;

(** Sets the robot options *)
let robotOption (option:robot_option_type) (value:int) =
   sendMessage (
		Printf.sprintf "RobotOption %i %i"
			(int_of_robot_option option) value);;

(** Sets the robot name *)
let name (name:string) =
   sendMessage (Printf.sprintf "Name %s" name);;

(** Sets the robot colurs
    @param colour Colour of robot
	 @param away_colour Colour of robot in away state *)
let colour (colour:int) (away_colour:int) =
   sendMessage (Printf.sprintf "Colour %x %x" colour away_colour);;

(** Rotate something, in angular velocity
   @param what What to rotate, a list of things
   @param angle Angle *)
let rotate (what:rotate_type list) (angle:float) =
   sendMessage (
		Printf.sprintf "Rotate %i %f"
         (* Calculates the sum of the parameters *)
			(List.fold_left (fun a b -> a + (int_of_rotate b)) 0 what) angle);;


(** Rotate something a exact angle
   @param what What to rotate, a list of things
   @param angular Angular Speed
   @param angle Angle to rotate *)
let rotateTo (what:rotate_type list) (angular:float) (angle:float) =
   sendMessage (
      Printf.sprintf "RotateTo %i %f %f"
         (* Calculates the sum of the parameters *)
         (List.fold_left (fun a b -> a + (int_of_rotate b)) 0 what)
				angular angle);;

(** Rotate something an amount
   @param what What to rotate, a list of things
   @param angular Angular Speed
   @param angle Angle *)
let rotateAmount (what:rotate_type list) (angular:float) (angle:float) =
   sendMessage (
		Printf.sprintf "RotateAmount %i %f %f"
         (* Calculates the sum of the parameters *)
			(List.fold_left (fun a b -> a + (int_of_rotate b)) 0 what)
				angular angle);;

(** Rotate something an amount
   @param what What to rotate, a list of things
   @param angular Angular Speed
	@param left Left Angle
	@param right Right Angle
	*)
let sweep (what:rotate_type list) (angular:float) (left:float) (right:float) =
   sendMessage (
		Printf.sprintf "RotateTo %i %f %f %f"
         (* Calculates the sum of the parameters *)
			(List.fold_left (fun a b -> a + (int_of_rotate b)) 0 what)
				angular left right);;

(** Accelerate *)
let accelerate (value:float) =
   sendMessage (Printf.sprintf "Accelerate %f" value);;

(** Put Brake *)
let brake (portion:float) =
   sendMessage (Printf.sprintf "Brake %f" portion);;

(** Shoot *)
let shoot (energy:float) =
   sendMessage (Printf.sprintf "Shoot %f" energy);;

(** Say something *)
let print (message:string) =
   sendMessage (Printf.sprintf "Print %s" message);;

(** Debug Message *)
let debug (message:string) =
   sendMessage (Printf.sprintf "Debug %s" message);;

(** Debug line *)
let debugLine (angle1:float) (radius1:float)
              (angle2:float) (radius2:float) =
   sendMessage (Printf.sprintf "DebugLine %f %f %f %f"
  					angle1 radius1 angle2 radius2);;

(** Debug circle *)
let debugCircle (center_angle:float) (center_radius:float)
                (circle_radius:float) =
   sendMessage (Printf.sprintf "DebugCircle %f %f %f"
  					center_angle center_radius circle_radius);;

(** Main loop flag *)
let robot_running = ref true;;

(** Ends main loop *)
let exitRobot () = robot_running := false;;

(************************************************************************)

(************************************)
(*   Messages from server to robots *)
(************************************)

(** User robot class with callbacks *)
class virtual robot =
   object (self)
      method initialize (first:bool) = ()
      method yourName (name:string) = ()
      method yourColour (color:int) = ()
      method gameOption (option:game_option_type) (value:float) =
					setGameOption option value
      method gameStarts = ()
      method radar (distance:float) (observedObject:object_type)
                   (radarAngle:float) = ()
      method info (time:float) (speed:float) (cannonAngle:float) = ()
      method coordinates (x:float) (y:float) (angle:float) = ()
      method robotInfo (energy:float) (teammate:bool) = ()
      method rotationReached (what:rotate_type list) = ()
      method energy (energy:int) = ()
      method robotsLeft (robots:int) = ()
      method collision (observedObject:object_type) (angle:float) = ()
      method warning (warning:warning_type) (message:string) = ()
      method dead = ()
      method gameFinishes = ()
      method exitRobot = exitRobot ()
   end


(************************************************************************)

(**
 * The parser
 * @param robot The user robot
 *)
let parser (the_robot:robot) =
   try
		let line = read_line () in
	   (* prerr_endline (">> "^line); *)
		let line_input = Scanf.Scanning.from_string line in
		try
		let command = (Scanf.bscanf line_input "%s" (fun a -> a)) in
			match String.lowercase command with
				"initialize" ->
				Scanf.bscanf line_input " %i"
						(function
							  1 -> the_robot#initialize true
							| _ -> the_robot#initialize false)
			 | "yourname" ->
					Scanf.bscanf line_input " %s" the_robot#yourName
			 | "yourcolour" ->
					Scanf.bscanf line_input " %x" the_robot#yourColour
			 | "gameoption" ->
					Scanf.bscanf line_input " %i %f"
						(fun option value ->
							the_robot#gameOption (game_option_of_int option) value)
			 | "gamestarts" -> the_robot#gameStarts
			 | "radar" ->
					Scanf.bscanf line_input " %f %i %f"
						(fun distance observed angle ->
							the_robot#radar distance (object_of_int observed) angle)
			 | "info" ->
					Scanf.bscanf line_input " %f %f %f" the_robot#info
			 | "robotinfo" ->
					Scanf.bscanf line_input " %f %i"
						(fun energy teammate ->
							if teammate = 1 then the_robot#robotInfo energy true
							else the_robot#robotInfo energy false)
			 | "coordinates" ->
					Scanf.bscanf line_input " %f %f %f" the_robot#coordinates
			 | "rotationreached" ->
					Scanf.bscanf line_input " %i"
						(fun what -> the_robot#rotationReached
							(rotate_list_of_int what))
			 | "energy" -> Scanf.bscanf line_input " %i" the_robot#energy
			 | "robotsleft" -> Scanf.bscanf line_input " %i" the_robot#robotsLeft
			 | "collision" ->
					Scanf.bscanf line_input " %i %f"
						(fun observed angle ->
							the_robot#collision (object_of_int observed) angle)
			 | "warning" ->
					let cab_size = (String.length "Warning")+2 in
					Scanf.bscanf line_input " %i"
						(fun warning ->
							the_robot#warning (warning_of_int warning)
								(String.sub line cab_size
									((String.length line)-cab_size)))
			| "dead" -> the_robot#dead
			| "gamefinishes" -> the_robot#gameFinishes
			| "exitrobot" -> the_robot#exitRobot
			| _ -> Printf.fprintf stderr
						"ML-RTBAPI ERROR: Unknown message \"%s\"\n" line;
					flush stderr
		with
			(Scanf.Scan_failure str) ->
				Printf.fprintf stderr
						"ML-RTBAPI ERROR: %s\n\tinput: \"%s\"" str line;
				flush stderr
   with
		 | Sys_blocked_io -> ()
		 | End_of_file -> ()
       | _ ->
				Printf.fprintf stderr
						"ML-RTBAPI ERROR: Unkown exception\n";
				flush stderr
;;

(************************************************************************)

(** Default Scanner *)
let scanner (the_robot:robot) =
   (* Set the sigusr1 handler *)
   Sys.set_signal Sys.sigusr1
		(Sys.Signal_handle (fun i -> parser the_robot));
   (* sets robot options *)
	robotOption Signal 10;
   (* Infinite loop *)
   while (!robot_running) do Unix.sleep 5; done;;

