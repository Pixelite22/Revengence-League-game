extends Control

signal turn_count_reached

var global_ctr := 100
var turn_reached := false

func turn_countdown(fighters: Array): #the array containing the 6 characters on the field.
	for player in fighters:
		player.hero_stats.time -= 1
		if player.hero_stats.time <= 0:
			player.hero_stats.time = 0
		print(player.hero_stats.name, " has ", player.hero_stats.time, " time counters left.")
	
	for player in fighters:
		if player.hero_stats.time <= 0:
			turn_reached = true
			print(turn_reached)
			turn_count_reached.emit(turn_reached)
			return #turn_reached
#			break

	await get_tree().create_timer(0.05).timeout #prevents errors and stack overflow
	turn_countdown(fighters)

func turn_reset(player: Player):
	if player:
		player.hero_stats.time = player.hero_stats.max_time
		turn_reached = false
#		turn_count_reached.emit(false)
