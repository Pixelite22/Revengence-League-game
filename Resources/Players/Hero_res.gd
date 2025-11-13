extends Resource
class_name Hero

signal stats_changed

@export_group("Player Base Stats")
@export var name: String
@export var command_deck: commands
@export var max_health := 1
@export var base_strength := 1
@export var base_defense := 1
@export var base_speed := 1 #?

#Turn Count Stuff
var max_time : int
var time : int


@export_group("Player Visuals")
@export var sprites: SpriteFrames
@export var count_img: Texture2D

#What is going to be the variables for all the stats.
var aggro_flag := false
var health: int
var strength: int

#Adds an instance of a character
func create_instance():
	var instance: Hero = self.duplicate() #Create an instance, of type Hero, and set it equal to a duplication of this one
	instance.health = max_health #Set's health as it should
	return instance #Returns the character to be called.

#Function handles speed
func speed():
	max_time = 100 - base_speed #Subtract speed from 100 to find how many ticks each turn will take
	time = max_time #Set time equal to those ticks.  This variable will be edited in other scripts
