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

(** ML-RTBAPI example robot *)
class example_robot =
   object (self)
      inherit robot
      method initialize (first:bool) =
		   if first then 
		   	name "Caml-RTBApi Example v0.0.1";
		      colour 0xffaaaa 0xaaaaff
      method radar (distance:float) (observedObject:object_type)
                   (radarAngle:float) =
         match observedObject with
            Robot -> shoot (100.0/.distance);
          | Wall  -> if (distance < 10.) then begin
                        brake 1.;
                        accelerate 0.;
                        rotateAmount [RotateRobot] 100. 0.05;
                        rotateTo [RotateCannon; RotateRadar] 100. 0.;
                     end
                     else begin
                        brake 0.;
                        accelerate 1.;
                     end
          | _ -> brake 1.;
                 accelerate 0.;
                 rotateAmount [RotateRobot] 100. 0.05;
                 rotateTo [RotateCannon; RotateRadar] 100. 0.;
      method exitRobot =
			print "Sayonara baby...";
         exitRobot ()
   end


(** Program start point *)
let _ =
   scanner (new example_robot);;
