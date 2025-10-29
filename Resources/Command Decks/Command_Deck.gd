extends Resource
class_name commands

signal character_changed(old_char, new_char)
signal page_changed(old_page, new_page)

enum page {MAIN, ATTACK, SPECIAL, ITEMS, TARGETING}

enum Character {DRM, EPI, IMP, RED, SPIN, TAG}

@export_category("Player")
@export var character: Character

@export_category("Attack Type")
@export var physical_attack_type: String : set = set_phys_attack
@export var distance_attack_type: String : set = set_dist_attack
var attack_type := {"Physical": physical_attack_type,
					"Distance": distance_attack_type}

@export_category("Special Movelist")
@export var special_moves: Dictionary

func set_phys_attack(value: String):
	physical_attack_type = value
	attack_type.Physical = value

func set_dist_attack(value: String):
	distance_attack_type = value
	attack_type.Distance = value

func attack_menu():
	pass
		

func special_menu():
	pass

func item_menu():
	pass
