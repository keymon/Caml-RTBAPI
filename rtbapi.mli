type rotate_type = RotateRobot | RotateCannon | RotateRadar
val int_of_rotate : rotate_type -> int
val rotate_list_of_int : int -> rotate_type list

type warning_type =
    UnknownMessage
  | ProcessTimeLow
  | MessageSentInIllegalState
  | UnknownOption
  | ObsoleteKeyword
  | NameNotGiven
  | ColourNotGiven
  | UnknownWarning
val warning_of_int : int -> warning_type

type game_option_type =
    RobotMaxRotate
  | CannonMaxRotate
  | RadarMaxRotate
  | RobotMaxAcceleration
  | RobotMinAcceleration
  | RobotStartEnergy
  | RobotMaxEnergy
  | RobotEnergyLevels
  | ShotSpeed
  | ShotMinEnergy
  | ShotMaxEnergy
  | ShotEnergyIncreaseSpeed
  | Timeout
  | DebugLevel
  | SendRobotCoordinates
  | UnknownOption
val game_option_of_int : int -> game_option_type
val string_of_game_option : game_option_type -> string

type robot_option_type =
    Signal
  | SendSignal
  | SendRotationReached
  | UseNonBlocking
val int_of_robot_option : robot_option_type -> int

type object_type =
    NoObject
  | Robot
  | Shot
  | Wall
  | Cookie
  | Mine
  | LastObjectType
val object_of_int : int -> object_type
val string_of_object : object_type -> string

val setGameOption : game_option_type -> float -> unit
val getGameOption : game_option_type -> float

val robotOption : robot_option_type -> int -> unit
val name : string -> unit
val colour : int -> int -> unit
val rotate : rotate_type list -> float -> unit
val rotateTo : rotate_type list -> float -> float -> unit
val rotateAmount : rotate_type list -> float -> float -> unit
val sweep : rotate_type list -> float -> float -> float -> unit
val accelerate : float -> unit
val brake : float -> unit
val shoot : float -> unit
val print : string -> unit
val debug : string -> unit
val debugLine : float -> float -> float -> float -> unit
val debugCircle : float -> float -> float -> unit
val robot_running : bool ref
val exitRobot : unit -> unit

class virtual robot :
  object
    method collision : object_type -> float -> unit
    method coordinates : float -> float -> float -> unit
    method dead : unit
    method energy : int -> unit
    method exitRobot : unit
    method gameFinishes : unit
    method gameOption : game_option_type -> float -> unit
    method gameStarts : unit
    method info : float -> float -> float -> unit
    method initialize : bool -> unit
    method radar : float -> object_type -> float -> unit
    method robotInfo : float -> bool -> unit
    method robotsLeft : int -> unit
    method rotationReached : rotate_type list -> unit
    method warning : warning_type -> string -> unit
    method yourColour : int -> unit
    method yourName : string -> unit
  end

val parser : robot -> unit

val scanner : robot -> unit
