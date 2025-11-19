extends Node2D

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
	if not command_menu.turn_ended.is_connected(turn_change):
		command_menu.turn_ended.connect(turn_change)
	#connecting the turn_count_reached signal to turn_change from the turn_order script
	if not turn_order.turn_count_reached.is_connected(turn_change):
		turn_order.turn_count_reached.connect(turn_change)
	
	#Defining the turn queue array, setting a hard first turn active player due to Spindle's foresight, and setting all the things needed for him
	#Realizing I should make the spindle thing into it's own function that can probably be called for all turns...
	turn_queue = [spindle, tag_team, dr_midnight, red_rocket, epiphany, impact]
	active_player = spindle
	command_menu.active_player = active_player
#	command_menu.fill_choice_options()
	text_box.text = active_player.name + " percieves a fight!  He moves first!"
	#Adds Characters symbols to timeline dynamically
	turn_countdowns.timeline_creation(turn_queue)
	
	#Loop to set speed for players... again could probably be it's own function
	for child in get_children():
		if child is Player:
			child.hero_stats.stats()
			print(child.name, " is geting there speed set to ", child.hero_stats.time)

#turn change logic function
func turn_change(turn_ready):
	print("Turn Change Reached!") #test line to ensure it was reached due to multiple signals getting us here
	if turn_ready == null or turn_ready == false: #If it is nobody's turn, or turn_ready signal is false
		turn_order.turn_countdown(turn_queue) #Call turn_countdown function in the turn_order script.  It handles counting through the ticks to assign turns
		turn_ready = turn_order.turn_reached #Whatever the turn_reached variable is in turn_orderm turn_ready gets assigned that
	
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
		command_menu.active_player = active_player #Set the command menu to show the correct moves for this player
		#command_menu.fill_choice_options() #Fill in the options for the command menu based on the array defined in command_menu script
		print("Shifting turn from ", last_player, " to ", active_player) #Test line to show working logic
		text_box.text = "It's " + active_player.name + "'s Turn!" #Change the text in the text box
		active_player_turn = true #Set active_player_turn to true, this stops the list from instantly looping through all the players to the last, and allows all the ones in the queue to have a turn
		last_player = active_player #Shift active player to last player for the test message (Will need to change if last_player is a needed variable in the future)
		turn_order.turn_reset(last_player) #reset the turn count of the new last_player (again might need to play with placement of this
		
		
	if possible_players.is_empty(): #when the possible_players list is empty
		turn_ready = false #Set turn_ready to false (might need to change variable name to reflect it better as it is untrue when a turn is done)

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
	var available_targets := []
	for child in get_children():
		if child is Player:
			if child.hero_stats.player_tag == false:
				available_targets.append(child)
	
	command_menu.targets = available_targets
