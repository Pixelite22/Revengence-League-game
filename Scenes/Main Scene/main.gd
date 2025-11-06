extends Node2D

@onready var tag_team: Player = $"Tag Team"
@onready var dr_midnight: Player = $"Dr Midnight"
@onready var epiphany: Player = $Epiphany
@onready var impact: Player = $Impact
@onready var red_rocket: Player = $"Red Rocket"
@onready var spindle: Player = $Spindle

var turn_queue : Array
var turn_queue_count : int

@onready var turn_order: Control = $"Turn Order"
@onready var battle_ui: Control = $"Battle UI"
@onready var command_menu: ItemList = $"Battle UI/Command Menu"
@onready var text_box: RichTextLabel = $"Battle UI/Text Box/RichTextLabel"


@onready var p1_mark: Marker2D = $"Character Placement/Player Placement/P1 Mark"
@onready var p2_mark: Marker2D = $"Character Placement/Player Placement/P2 Mark"
@onready var p3_mark: Marker2D = $"Character Placement/Player Placement/P3 Mark"
@onready var e1_mark: Marker2D = $"Character Placement/Enemy Placement/E1 Mark"
@onready var e2_mark: Marker2D = $"Character Placement/Enemy Placement/E2 Mark"
@onready var e3_mark: Marker2D = $"Character Placement/Enemy Placement/E3 Mark"

@onready var character_marker: AnimatedSprite2D = $"Character Marker"

var active_player : Player
var counter_pause := false
var last_player : Player

func _process(delta: float) -> void:
#	active_player = spindle
#	command_menu.active_player = active_player
	sprite_alignment(tag_team)
	sprite_alignment(dr_midnight)
	sprite_alignment(epiphany)
	sprite_alignment(impact)
	sprite_alignment(red_rocket)
	sprite_alignment(spindle)
	charcter_marker_placement(active_player)


func _ready() -> void:
	impact.position = p1_mark.global_position
	epiphany.position = p2_mark.global_position
	spindle.position = p3_mark.global_position
	
	red_rocket.position = e1_mark.global_position
	dr_midnight.position = e2_mark.global_position
	tag_team.position = e3_mark.global_position
	
	if not command_menu.turn_ended.is_connected(turn_change):
		command_menu.turn_ended.connect(turn_change)
	
	if not turn_order.turn_count_reached.is_connected(turn_change):
		turn_order.turn_count_reached.connect(turn_change)
	
	turn_queue = [spindle, tag_team, dr_midnight, red_rocket, epiphany, impact]
	active_player = spindle
	command_menu.active_player = active_player
	command_menu.fill_choice_options()
	text_box.text = active_player.name + " percieves a fight!  He moves first!"
	
	for child in get_children():
		if child is Player:
			child.hero_stats.speed()
			print(child.name, " is geting there speed set to ", child.hero_stats.time)

func turn_change(turn_ready):
	print("Turn Change Reached!")
	if turn_ready == null or turn_ready == false:
		turn_order.turn_countdown(turn_queue)
		turn_ready = turn_order.turn_reached
#	if last_player:
#		turn_order.turn_reset(last_player)
	

	var possible_players : Array = []
	for player in turn_queue:
		if player.hero_stats.time <= 0:
			possible_players.append(player)
		
	possible_players.sort_custom(speed_comparison)
	
	var active_player_turn := false
	while not possible_players.is_empty() && active_player_turn == false:
		print("Active Players: ", possible_players)
		active_player = possible_players.pop_front() #possible_players[0]
		command_menu.active_player = active_player
		command_menu.fill_choice_options()
		print("Shifting turn from ", last_player, " to ", active_player)
		text_box.text = "It's " + active_player.name + "'s Turn!"
		active_player_turn = true
		last_player = active_player
		turn_order.turn_reset(last_player)
		
		
	if possible_players.is_empty():
		turn_ready = false
	
	
	
#	if turn_queue_count < turn_queue.size() - 1:
#		turn_queue_count += 1
#		last_player = active_player
#		active_player = turn_queue[turn_queue_count]
#		command_menu.active_player = active_player
#		command_menu.fill_choice_options()
#		print("Shifting turn from ", last_player, " to ", active_player)
#		text_box.text = "It's " + active_player.name + "'s Turn!"
#	else:
#		print("Reached End of queue, looping back")
#		turn_queue_count = -1
#		turn_change()

#func end_turn():
#	active_player.hero_stats.time = active_player.hero_stats.max_time
#	turn_change(false)

func speed_comparison(p1, p2):
	if p1.hero_stats.base_speed > p2.hero_stats.base_speed:
		return true

func sprite_alignment(player: Player):
	if player.position == e1_mark.global_position or player.position == e2_mark.global_position or player.position == e3_mark.global_position:
		player.sprite_flip()

func charcter_marker_placement(player):
	character_marker.position = active_player.position - Vector2(0, 150)
	character_marker.play()
