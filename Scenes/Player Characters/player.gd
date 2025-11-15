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

func _process(delta: float) -> void:
	health_bar_update(hero_stats.health)

#Function to set hero
func set_hero(value: Hero): #Recieves a Hero 
	hero_stats = value.create_instance() #Calls create instance from the resource on the value it recieved
	
	if not hero_stats.stats_changed.is_connected(update_stats): #If stats_changed isn't connected to the update_stats function
		hero_stats.stats_changed.connect(update_stats) #connect it to the update_stats function
	
	update_player() #Call update_player to finalize the player

#Function sets the command deck to be what it should be
func set_command(value: commands): #receives command resource into value
	hero_command_deck = value #Sets hero_command_deck to that value

#This function locks in the player
func update_player():
	if not hero_stats is Hero: #If hero_stats is somehow not a Hero resource
		return #end function early
	if not is_inside_tree(): #If the player we are working with isn't yet in the tree
		await ready #wait for it to be in the tree
	
	sprite.sprite_frames = hero_stats.sprites #Set the sprite_frames of the player to be the sprite frames given in hero_stats.sprites
	sprite.play("Standing") #Play the standing sprite for this player
	update_stats() #Call update stats to finalize the stats

#This function locks in the stats
func update_stats():
	pass
	

#This function flips the sprites.  This is called when the player is on the right side of the screen in other scripts
func sprite_flip():
	sprite.flip_h = true

#Function that updates the health bar
func health_bar_update(health): #Recieves a health value (Could be int or float as I havent established which here)
	health_bar.value = hero_stats.health #Set the health_bar.value to that of the health stat in hero_stats
