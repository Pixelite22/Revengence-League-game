extends Control

signal turn_count_reached

var global_ctr := 100
var turn_reached := false

func turn_countdown(fighters: Array): #the array containing the 6 characters on the field.
	for player in fighters: #For players within the fighter array, that was passed
		player.hero_stats.time -= 1 #Decrement the time ticks by 1
		if player.hero_stats.time <= 0: #If the player has 0 or somehow less then 0 ticks left
			player.hero_stats.time = 0 #Set the ticks to 0 to prevent possible errors in later written code
#		print(player.hero_stats.name, " has ", player.hero_stats.time, " time counters left.") #Debug code
	
	for player in fighters: #Once again looping through the players in the fighter array
		if player.hero_stats.time == 0: #If the ticks are at or below 0
			turn_reached = true #Set the turn reached flag to true
#			print(turn_reached) #Debug turn_reached message to ensure things are going to plan
			turn_count_reached.emit(turn_reached) #Emit the turn_count_reached signal with the turn_reached flag which will be caught by the turn_change function in main
			return #turn_reached

	await get_tree().create_timer(0.05).timeout #prevents errors and stack overflow, as well as making the timeline not move instantly
	turn_countdown(fighters) #Continuously calls the function until a player hits 0 ticks and breaks it

#Function to reset a player after they take their turn
func turn_reset(player: Player): #Recieves a player to reset
	if player: #If there is infact a player
		player.hero_stats.time = player.hero_stats.max_time #Set their time to max_time
		turn_reached = false #Set turn_reached to false... might not be good actually incase there are multiple players
