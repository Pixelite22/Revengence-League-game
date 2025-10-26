extends Node2D

@onready var tag_team: Player = $"Tag Team"
@onready var dr_midnight: Player = $"Dr Midnight"
@onready var epiphany: Player = $Epiphany
@onready var impact: Player = $Impact
@onready var red_rocket: Player = $"Red Rocket"
@onready var spindle: Player = $Spindle


@onready var p1_mark: Marker2D = $"Character Placement/Player Placement/P1 Mark"
@onready var p2_mark: Marker2D = $"Character Placement/Player Placement/P2 Mark"
@onready var p3_mark: Marker2D = $"Character Placement/Player Placement/P3 Mark"
@onready var e1_mark: Marker2D = $"Character Placement/Enemy Placement/E1 Mark"
@onready var e2_mark: Marker2D = $"Character Placement/Enemy Placement/E2 Mark"
@onready var e3_mark: Marker2D = $"Character Placement/Enemy Placement/E3 Mark"

func _process(delta: float) -> void:
	sprite_alignment(tag_team)
	sprite_alignment(dr_midnight)
	sprite_alignment(epiphany)
	sprite_alignment(impact)
	sprite_alignment(red_rocket)
	sprite_alignment(spindle)


func _ready() -> void:
	impact.position = p1_mark.global_position
	epiphany.position = p2_mark.global_position
	spindle.position = p3_mark.global_position
	
	red_rocket.position = e1_mark.global_position
	dr_midnight.position = e2_mark.global_position
	tag_team.position = e3_mark.global_position

func sprite_alignment(player: Player):
	if player.position == e1_mark.global_position or player.position == e2_mark.global_position or player.position == e3_mark.global_position:
		player.sprite_flip()
