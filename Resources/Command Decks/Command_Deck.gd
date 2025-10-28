extends Resource
class_name commands

signal character_changed(old_char, new_char)
signal page_changed(old_page, new_page)

enum page {MAIN, ATTACK, SPECIAL, ITEMS, TARGETING}

@export_category("Attack Type")
@export var physical_attack_type: String
@export var distance_attack_type: String
var attack_type := {"Physical": physical_attack_type,
					"Distance": distance_attack_type}

@export_category("Special Movelist")
@export var special_moves: Dictionary
