extends CharacterBody2D
class_name Player


@export_category("Hero Details")
@export var hero_stats : Hero : set = set_hero
@export var hero_command_deck : commands #: set = set_command

@onready var sprite = $Sprite
@onready var health_bar: ProgressBar = $"Health Bar"

#func _ready() -> void:
#		hero_stats.health -= 5
#		health_bar_update(hero_stats.health)

func set_hero(value: Hero):
	hero_stats = value.create_instance()
	
	if not hero_stats.stats_changed.is_connected(update_stats):
		hero_stats.stats_changed.connect(update_stats)
	
	update_player()

func set_command(value: commands):
	hero_command_deck = value

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

func health_bar_update(health):
	health_bar.value = hero_stats.health
