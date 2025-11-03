extends Control

signal turn_count_continued

var global_ctr := 100
var turn_reached := false

func turn_countdown(fighters: Array): #the array containing the 6 characters on the field.
	for player in fighters:
		player.hero_stats.time =- 1
		if player.hero_stats.time <= 0:
			turn_reached = true
		return turn_reached

func turn_reset(player: Player):
	player.hero_stats.time = player.hero_stats.max_time
	turn_reached = false
	turn_count_continued.emit
