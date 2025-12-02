extends Node2D

signal turn_started(active_player_stats : Hero)
signal effects_processed()

#Character Variables.  Might be removing when I add dynamic character choice
@onready var tag_team: Player = $"Tag Team"
@onready var dr_midnight: Player = $"Dr Midnight"
@onready var epiphany: Player = $Epiphany
@onready var impact: Player = $Impact
@onready var red_rocket: Player = $"Red Rocket"
@onready var spindle: Player = $Spindle

#Defining Turn Queue for turn logic later
var turn_queue : Array
var turn_queue_count : int

#Node Variables for easier referal in code
@onready var turn_order: Control = $"Turn Order"
@onready var battle_ui: Control = $"Battle UI"
@onready var command_menu: ItemList = $"Battle UI/Command Menu"
@onready var text_box: RichTextLabel = $"Battle UI/Text Box/RichTextLabel"
@onready var turn_countdowns: Path2D = $"Battle UI/Turn Countdowns"

#Marker Nodes for character placement
@onready var p1_mark: Marker2D = $"Character Placement/Player Placement/P1 Mark"
@onready var p2_mark: Marker2D = $"Character Placement/Player Placement/P2 Mark"
@onready var p3_mark: Marker2D = $"Character Placement/Player Placement/P3 Mark"
@onready var e1_mark: Marker2D = $"Character Placement/Enemy Placement/E1 Mark"
@onready var e2_mark: Marker2D = $"Character Placement/Enemy Placement/E2 Mark"
@onready var e3_mark: Marker2D = $"Character Placement/Enemy Placement/E3 Mark"

#Probably soon to be defunct marker for an arrow to show which character's turn it is
@onready var character_marker: AnimatedSprite2D = $"Character Marker"

#More variables for turn logic
var active_player : Player
var counter_pause := false
var last_player : Player

#The always happening function
func _process(delta: float) -> void:
	#Most of this function is made up of temporary things
	#Sprite alignment makes sure characters face the right way dependent on which side of the screen they are placed on
	#I am realizing I should make it recieve an array and loop through that instead of calling it like this
	sprite_alignment(tag_team)
	sprite_alignment(dr_midnight)
	sprite_alignment(epiphany)
	sprite_alignment(impact)
	sprite_alignment(red_rocket)
	sprite_alignment(spindle)
	
	#Call to a possibly soon to be defunct function to align a character marker to show who's turn it is
	charcter_marker_placement(active_player)
	
	#This calls the timeline function in turn_countdown_ui to control the
	#timeline in game for turn order.  The symbols move to show who's turn is up
	turn_countdowns.timeline(turn_queue)
	
	if active_player.hero_stats.health <= 0:
		active_player.hero_stats.defeated = true


#The happens only once when the game is booted function
func _ready() -> void:
	#Like above, this is mostly temporary for while building so everyone is where they need to be
	#Setting the positions of the players
	impact.position = p1_mark.global_position
	epiphany.position = p2_mark.global_position
	spindle.position = p3_mark.global_position
	red_rocket.position = e1_mark.global_position
	dr_midnight.position = e2_mark.global_position
	tag_team.position = e3_mark.global_position
	
	#This is a temporary setting of player flags to make targeting viable in this test enviroment
	spindle.hero_stats.player_tag = true
	impact.hero_stats.player_tag = true
	epiphany.hero_stats.player_tag = true
	
	#connecting the turn_ended signal to turn_change from the command_menu script
	if not command_menu.turn_ended.is_connected(turn_ready_check):
		command_menu.turn_ended.connect(turn_ready_check)
	#connecting the turn_count_reached signal to turn_change from the turn_order script
	if not turn_order.turn_count_reached.is_connected(turn_ready_check):
		turn_order.turn_count_reached.connect(turn_ready_check)
	
	#Defining the turn queue array, setting a hard first turn active player due to Spindle's foresight, and setting all the things needed for him
	#Realizing I should make the spindle thing into it's own function that can probably be called for all turns...
	turn_queue = [spindle, tag_team, dr_midnight, red_rocket, epiphany, impact]
	active_player = spindle
	command_menu.active_player = active_player
	text_box.text = active_player.name + " percieves a fight!  He moves first!"
	#Adds Characters symbols to timeline dynamically
	turn_countdowns.timeline_creation(turn_queue)
	
	#Loop to set speed for players... again could probably be it's own function
	for child in get_children():
		if child is Player:
			child.hero_stats.stats()
			print(child.name, " is geting there speed set to ", child.hero_stats.time)

func turn_ready_check(turn_ready):
	print("Turn Ready Check reached")
	if turn_ready == null or turn_ready == false: #If it is nobody's turn, or turn_ready signal is false
		turn_order.turn_countdown(turn_queue) #Call turn_countdown function in the turn_order script.  It handles counting through the ticks to assign turns
		turn_ready = turn_order.turn_reached #Whatever the turn_reached variable is in turn_orderm turn_ready gets assigned that
	elif turn_ready:
		turn_change()

#turn change logic function
func turn_change():
	print("Turn Change Reached!") #test line to ensure it was reached due to multiple signals getting us here
#	if turn_ready == null or turn_ready == false: #If it is nobody's turn, or turn_ready signal is false
#		turn_order.turn_countdown(turn_queue) #Call turn_countdown function in the turn_order script.  It handles counting through the ticks to assign turns
#		turn_ready = turn_order.turn_reached #Whatever the turn_reached variable is in turn_orderm turn_ready gets assigned that
	
	#This handles logic of multiple players sharing a turn, as well as just being what all turns go through
	var possible_players : Array = [] #Start an empty array for players whos turn it is
	for player in turn_queue: #Loop through all players in turn_queue
		if player.hero_stats.time <= 0: #To find all the ones who don't have to wait for their turn anymore
			possible_players.append(player) #and add them to the possible_players array
	
	possible_players.sort_custom(speed_comparison) #Then pass the possible players to this to sort them based on their speed stats, defined in the speed comparison function
	
	var active_player_turn := false #Create an active_player_turn variable and set it to false
	while not possible_players.is_empty() && not active_player_turn: #While the possible players array is not empty and active_player_turn is false
		print("Active Players: ", possible_players) #Test statement showing possible players whos turn it could be
		active_player = possible_players.pop_front() #Set the active_player to whomever is at the front of the sorted possible_players array, and remove them from the array
		
		if active_player == last_player: #If the last player is the same as the current one (i.e. double turn)
			if possible_players.size() > 1: #If there is another player in the queue
				turn_ready_check(true) #loop back to skip the current ones turn but still move ot the next in queue
				break #break this loop
			else: #if there isn't another in the queue
				turn_ready_check(false) #loop back to skip the current ones turn and move the queue along
				break #break this loop
		
		command_menu.active_player = active_player #Set the command menu to show the correct moves for this player
		print("Shifting turn from ", last_player, " to ", active_player) #Test line to show working logic
		text_box.text = "It's " + active_player.name + "'s Turn!" #Change the text in the text box
		turn_started.emit(active_player.hero_stats)
		last_player = active_player #Shift active player to last player for the test message (Will need to change if last_player is a needed variable in the future)
		turn_order.turn_reset(last_player) #reset the turn count of the new last_player (again might need to play with placement of this
		
		await effects_processed
		print("Effects have been processed")
		command_menu.enable_menus()
		
		print(active_player.hero_stats.health)
		#active_player_turn = true #Set active_player_turn to true, this stops the list from instantly looping through all the players to the last, and allows all the ones in the queue to have a turn
		#turn_order.turn_reset(last_player) #reset the turn count of the new last_player (again might need to play with placement of this
		
#	if possible_players.is_empty(): #when the possible_players list is empty
#		turn_ready = false #Set turn_ready to false (might need to change variable name to reflect it better as it is untrue when a turn is done)

func _on_turn_started(active_player_stats: Hero) -> void:
	#This function handles all the status effects
	
	#Burn Logic
	if active_player_stats.burn: #if player has burn tag
		var burn_heal : int #Define a variable for possibly healing from the burn
		var burn_dmg = randi_range(1, 5) #Define a variable that sets itself to a random nummber between 1 and 5
		
		active_player_stats.health -= burn_dmg #Subtract the damage from the active player
		text_box.text += "\n They were burned for " + str(burn_dmg) + " damage!!" #Output a message calling attention to the damage
		burn_heal = randi_range(1, 5) #roll a d3 for healing chance
		if burn_heal == 1: #If they rolled a 1
			active_player_stats.burn = false #They are no longer burned
			text_box.text += "\n But!  They healed from the burn after!!!" #Output a message calling attention to healing from burn
	
	#Posion Logic
	if active_player_stats.poison: #If player has a poison tag
		var psn_level_change #variable define for possible change in poison severity
		var psn_dmg = clampi(active_player_stats.poison_level, 0, 3)#variable for poison damage clamping the value between 0 and 3
		
		if active_player_stats.poison_level == 1: #If active player is poisoned with severity 1 poisoning
			psn_dmg = randi_range(1, 3) #Roll 1 - 3 damage
			active_player_stats.health -= psn_dmg #Deal rolled damage 
		elif active_player_stats.poison_level == 2: #If active player is poisoned with severity 2 poisoning
			psn_dmg = randi_range(3, 7) #roll 3-7 damage
			active_player_stats.health -= psn_dmg #Deal rolled damage
		elif active_player_stats.poison_level == 3: #If active player is poisoned with severity 3 poisoning
			psn_dmg = randi_range(7, 12) #Roll 7-12 damage
			active_player_stats.health -= psn_dmg #Deal rolled damage
		text_box.text += "\n They took " + str(psn_dmg) + " poison damage!" #Call attention to damage taken in textbox
		
		psn_level_change = randi_range(1, 10) #Roll for the chance to change level of poison, or to heal from it
		if psn_level_change == 1: #If rolled a 1
			active_player_stats.poison = false #heal from the poison condition
			text_box.text += "\n But they worked the poison out of their system!!!" #message
		elif psn_level_change >= 7: #If rolled a 7 or higher
			active_player_stats.poison_level += 1 #Make the poison worse, won't go over 3 due to the clamp
			text_box.text += "\n And the poison has spread..." #message
	
	#Fear Logic
	if active_player_stats.fear: #if player is scared
		if not active_player_stats.fear_chk: #if the player hasn't been checked for fear slow down
			active_player_stats.max_time *= 2 #Slow down player
			active_player_stats.fear_chk = true #Show that they were checked for fear slow down
		
		if active_player_stats.fear_ctr > 0: #If the fear counter is greater then 0
			active_player_stats.fear_ctr -= 1 #decrement the time they are scared
			text_box.text += "\n They are scared!  They aren't sure when to attack!" #message
		else: #if fear counter is less then or equal to 0
			active_player_stats.fear_chk = false #Reset the fear check
			active_player_stats.max_time /= 2 #Speed the player back up to what they should be.
			text_box.text += "\n They got over the fear.  They are more certain about when to attack!" #message
	
	#Healing light 
	if active_player_stats.healing_light: #If the player is blessed with healing light
		var heal_amt = randi_range(1, 5) #Define a variable for the amount they will heal by between 1 and 5
		active_player_stats.health += heal_amt #heal them that much
		if active_player_stats.health >= active_player_stats.max_health: #If the player were to be overhealed
			active_player_stats.health == active_player_stats.max_health #Set the player back to max possible health
		text_box.text += "\n and through the power of healing light, they healed back " + str(heal_amt) #Message
		
		#Need logic to end the healing light condition, similar to that of fear
	
	#Sleep Logic
	if active_player_stats.sleep: #If player should be asleep
		var wake_chance = randi_range(0, 5) #Define a value for a chance to wake up between 0 and 5
		if wake_chance == 0: #If they roll a 0
			active_player_stats.sleep = false #They wake up
			text_box.text += "\n " + active_player.name + " woke up!" #and attention is called to this
			
		if active_player_stats.sleep: #If the player is still asleep after the above function, they rolled something other then a 0 and so
			command_menu.disable_menus() #Disable the chance to choose something
			text_box.text += "\n " + active_player.name + " is asleep!  They can't attack until the wake up!" #Add message saying why they can't move
			
			await get_tree().create_timer(3).timeout #Wait 3 seconds
			
			turn_ready_check(false) #Then send the player back to the turn change function so the next player can go
			effects_processed.emit() #Emit the needed signal that would be missed since
			return #we return here, ending the function early
	
		#Stun Logic
	if active_player_stats.stun: #If the player is stunned (note, can't be stunned and sleeped at the same time, or at least, stun won't show up if they are asleep)
		command_menu.disable_menus() #Remove access to choose an option
		text_box.text = " " + active_player.name + " is stunned!  Their turn is skipped!" #Message about why
		active_player.hero_stats.stun_disable() #Reenable the menu through function on player resource
		
		await get_tree().create_timer(3).timeout #wait 3 seconds
		
		effects_processed.emit() #Emit needed signal that would be missed since
		#turn_ready_check(false) #Push to the next turn
		return #We return here, ending the function early
		#command_menu.enable_menus() #Reenable the menus for those after the stunned player
	
	if active_player_stats.defeated:#If player is defeated
		command_menu.disable_menus() #Disable the menus
		text_box.text = " " + active_player.name + " was defeated, moving to next player..." #Replace all text with how they were defeated
		
		await get_tree().create_timer(3).timeout #wait 3 seconds
		
		effects_processed.emit() #Emit signal
		turn_ready_check(false) #and send back to function because
		return #return early, ending the function
	
	effects_processed.emit() #emit the signal at the end of this function to show all signals were processed.


func speed_comparison(p1, p2): #Comparison function so the turn logic can sort simultaneous turns correctly
	if p1.hero_stats.base_speed > p2.hero_stats.base_speed: #Whomever is faster, goes first
		return true

func sprite_alignment(player: Player): #Simple function to flip a sprite if it is on the right side of the screen
	if player.position == e1_mark.global_position or player.position == e2_mark.global_position or player.position == e3_mark.global_position:
		player.sprite_flip()

func charcter_marker_placement(player): #possibly defunct function to correctly place the marker to show who's turn it is
	character_marker.position = active_player.position - Vector2(0, 150)
	character_marker.play()


func _on_battle_ui_target_menu_opened() -> void: 
	var available_targets := [] #Define an array for avaialable people to target with an action
	for child in get_children(): #For all children in the tree
		if child is Player: #If those children are Players
			if child.hero_stats.player_tag == false: #And they they don't have a player tag
				available_targets.append(child) #Make them available by placing them into the array
	
	command_menu.targets = available_targets #fill the array targets in the command menu node with the targets chosen as available
