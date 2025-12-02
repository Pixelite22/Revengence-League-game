extends Resource
class_name Hero

signal stats_changed

@export_group("Player Base Stats")
@export var name: String
@export var command_deck: commands
@export var max_health := 1
@export var base_melee := 1
@export var base_power := 1
@export var base_defense := 1
@export var base_speed := 1 #?

#Turn Count Stuff
var max_time : int
var time : int


@export_group("Player Visuals")
@export var sprites: SpriteFrames
@export var count_img: Texture2D

var player_tag := false

#What is going to be the variables for all the stats.
var aggro_flag := false
var health: int
var melee: int
var power: int
var defense: int

#Condition Flags
@export_group("Status Effects")
#Bad
@export var stun := false
@export var burn := false
@export var poison := false
@export var fear := false
@export var sleep := false
@export var defeated := false
#Good
@export var healing_light := false

#Posion Logic
@export_group("Status Details")
@export var poison_level : int = clamp(1, 1, 3)
@export var fear_ctr : int
@export var fear_chk : bool

#Adds an instance of a character
func create_instance():
	var instance: Hero = self.duplicate() #Create an instance, of type Hero, and set it equal to a duplication of this one
	instance.health = max_health #Set's health as it should
	return instance #Returns the character to be called.

#Function handles stat setting
func stats():
	health = clampi(max_health, 0, max_health) #Set Health
	melee = base_melee #Set melee
	power = base_power #Set power
	defense = base_defense #Set defense
	max_time = 100 - base_speed #Subtract speed from 100 to find how many ticks each turn will take
	time = max_time #Set time equal to those ticks.  This variable will be edited in other scripts

#Basic Attacks`
func physical(target: Player): #function for physical
	print(name, " attacks ", target.name, " with a physical attack!!!")
	target.hero_stats.health -= melee #subtract melee stat from the targets health
	print(target.hero_stats.health)

func distance(target): #function for distance
	print(name, " attacks ", target.name, " with a distance attack!!!")
	target.hero_stats.health -= power #subtract power stat from the targets health

#Condition Functions
func stun_disable():
	stun = false

#Impact Attacks
func giga_punch(target):
	target.hero_stats.health -= 2 * melee
	target.hero_stats.stun = true

func mega_slam(target):
	pass

#Spindle Attacks
func ground_phazing(target):
	pass

func holding_pattern(target):
	pass

func slingshot_special(target):
	pass
