extends Resource
class_name commands

#Signals to pass to other scripts
signal character_changed(old_char, new_char)
signal page_changed(old_page, new_page)

#enum for types of pages.  Might be worth keeping
enum page {MAIN, ATTACK, SPECIAL, ITEMS, TARGETING}

#Enum for distinguishing characters.  Might be worth keeping
enum Character {DRM, EPI, IMP, RED, SPIN, TAG}

#Set the character to one of the characters
@export_category("Player")
@export var character: Character

#Set up the not special attacks
@export_category("Attack Type")
@export var physical_attack_type: String : set = set_phys_attack
@export var distance_attack_type: String : set = set_dist_attack
var attack_type := {"Physical": physical_attack_type,
					"Distance": distance_attack_type}

#Set up the special attacks
@export_category("Special Movelist")
@export var special_moves: Dictionary

func set_phys_attack(value: String): 
#	physical_attack_type = value
	attack_type.Physical = value #Set the physical attack type to the passed value from the resource

func set_dist_attack(value: String):
#	distance_attack_type = value
	attack_type.Distance = value #Set the physical attack type to the passed value from the resource

func attack_menu():
	pass

func special_menu():
	pass

func item_menu():
	pass
