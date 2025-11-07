extends Path2D

#Each Countdown
#@onready var spindle_turn_countdown: PathFollow2D = $"Spindle Turn Countdown"
#@onready var red_rocket_turn_countdown: PathFollow2D = $"Red Rocket Turn Countdown"
#@onready var impact_turn_countdown: PathFollow2D = $"Impact Turn Countdown"
#@onready var epiphany_turn_countdown: PathFollow2D = $"Epiphany Turn Countdown"
#@onready var tag_team_turn_countdown: PathFollow2D = $"Tag Team Turn Countdown"
#@onready var dr_midnight_turn_countdown: PathFollow2D = $"Dr Midnight Turn Countdown"

func timeline(fighters: Array):
	for character in fighters:
		for children in get_children():
			if character.name == children.name:
				children.progress_ratio = float(character.hero_stats.time) / float(character.hero_stats.max_time)
				if children.progress_ratio == 1:
					children.progress_ratio = 0

func timeline_creation(fighters: Array):
	for character in fighters:
		var character_countdown = PathFollow2D.new()
		var character_countdown_img = Sprite2D.new()
		character_countdown.name = character.name
		character_countdown.loop = false
		add_child(character_countdown)
		character_countdown.add_child(character_countdown_img)
		character_countdown_img.texture = character.hero_stats.count_img
		print(character_countdown)
