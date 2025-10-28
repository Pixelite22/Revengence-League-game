extends Resource
class_name Hero

signal stats_changed

@export_group("Player Base Stats")
@export var name: String
@export var command_deck: commands
@export var max_health := 1
@export var base_strength := 1
@export var base_defense := 1
@export var base_speed := 1.0 #?



@export_group("Player Visuals")
@export var sprites: SpriteFrames

var aggro_flag := false
var health: int
var strength: int

func create_instance():
	var instance: Hero = self.duplicate()
	instance.health = max_health
	return instance
