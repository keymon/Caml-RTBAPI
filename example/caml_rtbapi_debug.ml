(***************************************************************************
   	                       _            _   _                 _
   	    ___ __ _ _ __ ___ | |      _ __| |_| |__   __ _ _ __ (_)
   	   / __/ _` | '_ ` _ \| |_____| '__| __| '_ \ / _` | '_ \| |
   	  | (_| (_| | | | | | | |_____| |  | |_| |_) | (_| | |_) | |
    	   \___\__,_|_| |_| |_|_|     |_|   \__|_.__/ \__,_| .__/|_|
  	                                                      |_|

                                                    by Keymon
         example robot

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

open Rtbapi;;

(** RTBAPI Debug robot *)
class debug_robot =
   let debug msx = Printf.fprintf stderr "%s\n" msx ; flush stderr in
   object (self)
      inherit robot
      method initialize (first:bool) =
         if first then begin
  		   	name "Caml-RTBApi Debug v0.0.1";
  		      colour 0xffaaaa 0xaaaaff;
	         debug "Init first"
         end
         else
	         debug "Init no first"
      method yourName (name:string) =
         debug ("name "^name)
      method yourColour (color:int) =
         debug (Printf.sprintf "colour %x" color)
      method gameOption (option:game_option_type) (value:float) =
         debug (Printf.sprintf "game option %s %f"
					(string_of_game_option option) value)
      method gameStarts =
         debug "Game Starts"
      method radar (distance:float) (observedObject:object_type)
                   (radarAngle:float) =
         debug (Printf.sprintf "Radar %f %s %f" distance
				(string_of_object observedObject) radarAngle);
         rotateAmount [RotateCannon; RotateRadar] 100. 0.05;
      method info (time:float) (speed:float) (cannonAngle:float) =
         debug (Printf.sprintf "Info %f %f %f" time speed cannonAngle)
      method coordinates (x:float) (y:float) (angle:float) =
         debug (Printf.sprintf "Coordinates %f %f %f" x y angle)
      method robotInfo (energy:float) (teammate:bool) =
         debug (Printf.sprintf "RobotInfo %f %s" energy
			                      (string_of_bool teammate))
      method rotationReached (what:rotate_type list) =
         debug "RotationReached"
      method energy (energy:int) =
         debug (Printf.sprintf "Energy %i" energy)
      method robotsLeft (robots:int) =
         debug (Printf.sprintf "RobotsLeft %i" robots)
      method collision (observedObject:object_type) (angle:float) =
         debug (Printf.sprintf "Collision %s %f"
			                      (string_of_object observedObject)
										 angle)
      method warning (warning:warning_type) (message:string) =
         debug (Printf.sprintf "Warning %s" message)
      method dead =
         debug "Dead"
      method gameFinishes =
         debug "GameFinishes"
   end

(** Program start point *)
let _ =
   scanner (new debug_robot);;
