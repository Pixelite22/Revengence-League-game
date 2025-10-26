extends CharacterBody2D
class_name Player

@export var hero_stats : Hero : set = set_hero
@onready var sprite = $Sprite



func set_hero(value: Hero):
	hero_stats = value.create_instance()
	
	if not hero_stats.stats_changed.is_connected(update_stats):
		hero_stats.stats_changed.connect(update_stats)
	
	update_player()

func update_player():
	if not hero_stats is Hero:
		return
	if not is_inside_tree():
		await ready
	
	sprite.sprite_frames = hero_stats.sprites
	sprite.play("Standing")
	update_stats()

func update_stats():
	pass
	

func sprite_flip():
	sprite.flip_h = true
