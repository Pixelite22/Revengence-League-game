extends Path2D

#Each Countdown
#@onready var spindle_turn_countdown: PathFollow2D = $"Spindle Turn Countdown"
#@onready var red_rocket_turn_countdown: PathFollow2D = $"Red Rocket Turn Countdown"
#@onready var impact_turn_countdown: PathFollow2D = $"Impact Turn Countdown"
#@onready var epiphany_turn_countdown: PathFollow2D = $"Epiphany Turn Countdown"
#@onready var tag_team_turn_countdown: PathFollow2D = $"Tag Team Turn Countdown"
#@onready var dr_midnight_turn_countdown: PathFollow2D = $"Dr Midnight Turn Countdown"

#This function determines the icon placement for each players icon on the timeline
func timeline(fighters: Array): #Recieves an array full of players
	for character in fighters: #for each player in the fighters array
		for children in get_children(): #and for each child in the tree of Turn Countdowns node
			if character.name == children.name: #If the name of the character is the same as the name of a child node
				children.progress_ratio = float(character.hero_stats.time) / float(character.hero_stats.max_time) #Set progress ratio of the child to the value of the characters time over the characters maximum time
				if children.progress_ratio == 1: #If the progress ratio is equivalent to 1
					children.progress_ratio = 0 #Set it to 0, So the icon is shown at the right on that player's turn

#This function adds icons dynamically based on which characters are in the fight
func timeline_creation(fighters: Array): #Recieves an array full of players
	for character in fighters: #For each character in that recieved array
		var character_countdown = PathFollow2D.new() #Create a pathfollow2d node for the icon to follow
		var character_countdown_img = Sprite2D.new() #and a sprite node to BE the icon
		character_countdown.name = character.name #Set the name of the pathfollow node to be the same as the player
		add_child(character_countdown) #and add the pathfollow node to the tree
		character_countdown.add_child(character_countdown_img)  #Then add the icon as a child of the pathfollow node
		character_countdown_img.texture = character.hero_stats.count_img #and set the icon to that of the icon given in the character resource
