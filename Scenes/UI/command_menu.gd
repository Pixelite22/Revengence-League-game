extends ItemList

signal turn_ended
signal target_menu_opened

var menu := "base"
var last_menu : String
var menu_options = ["base", "attack", "special", "items", "target"]
var active_player : Player
var choice_options : Array = []
var targets := []
var action 

func _ready() -> void: #When loading into the scene
	clear() #Clear the options if there are any
	#Dynamically add options to the basic command deck
	add_item("Attack", null, true)
	add_item("Special", null, true)
	add_item("Defend", null, true)
	add_item("Items", null, true)
	add_item("Run", null, true)
	add_item("Skip Turn", null, true)

func fill_choice_options():
	if active_player: #If active_player isn't null
		choice_options.clear() #Clear the choice_options array
		for options in active_player.hero_command_deck.special_moves: #and for options in the current players command deck
			choice_options.append(options) #Append those options to the choice_options array

#Direct to the correct function based on choice
func _on_item_selected(index: int) -> void:
	if menu == "base":
		base_menu(index)
	if menu == "attack":
		attack_menu(index)
	if menu == "special":
		special_menu(index)
	if menu == "items":
		item_menu(index)
	if menu == "target":
		target_menu(index)

#menu transition function
func menu_transition(new_menu):
	last_menu = menu #Set the last to the menu for when a back option exists
	menu = new_menu #Set menu to the new_menu value
	change_options(menu) #Call change options functoin

#Handles a most of the menu logic
func change_options(new):
	clear() #Start by clearing menu
	if new == "base": #If the new value is base, add these items 
		add_item("Attack", null, true)
		add_item("Special", null, true)
		add_item("Defend", null, true)
		add_item("Items", null, true)
		add_item("Run", null, true)
		add_item("Skip Turn", null, true)
	if new == "attack": #If the new value is attack
		if active_player.hero_command_deck: #and there is an active player
			add_item(active_player.hero_command_deck.attack_type.Physical, null, true) #Add the physical equivalent attack
			add_item(active_player.hero_command_deck.attack_type.Distance, null, true) #Add the distance equivalent attack
			add_item("Back")
		else: # and if there isn't an active player, add these placeholders
			add_item("Physical Option", null, true)
			add_item("Distance Option", null, true)
			add_item("Back", null, true)
	if new == "special": #If special
		if active_player.hero_command_deck: #and there is a player
			for key in active_player.hero_command_deck.special_moves.keys(): #for each move in the active player command deck
				add_item(active_player.hero_command_deck.special_moves[key], null, true) #add them to the menu
			add_item("Back", null, true) #and add back
		else: #else placeholder
			add_item("Special 1", null, true)
			add_item("Special 2", null, true)
			add_item("Back", null, true)
	if new == "items": #if items (placeholders for now)
		add_item("Item 1", null, true)
		add_item("Item 2", null, true)
		add_item("Back", null, true)
	if new == "target":
		target_menu_opened.emit()
		for enemy in targets:
			add_item(str(enemy.name), null, true)
		add_item("Back", null, true)


#From here on I should find a way to make these functions more dynamic since the moves can vary from 
#player to player but the back button always needs to stay in the same spot at the end.
#Every function from here on is just menu logic based on choice
func base_menu(index: int):
	if index == 0:
		print("attack Selected")
		menu_transition("attack")
	if index == 1:
		print("Special Attack Selected")
		menu_transition("special")
	if index == 2:
		print("Defend Selected")
	if index == 3:
		print("Items Selected")
		menu_transition("items")
	if index == 4:
		print("Run Selected... You Coward...")
	if index == 5:
		print("Skip Turn Selected")
		turn_ended.emit(null)

func attack_menu(index: int):
	if index == 0: #Physical Option for Attack
		#action = active_player.hero_command_deck.attack_type["Physical"]
		action = "physical"
		menu_transition("target")
	if index == 1: #Distance Option for Attack
		#action = active_player.hero_command_deck.attack_type["Distance"]
		action = "distance"
		menu_transition("target")
	if index == 2:
		menu_transition("base")

func special_menu(index: int):
	if index != choice_options.size():
		print("Move Selected: ", active_player.hero_command_deck.special_moves[index])
		action = active_player.hero_command_deck.special_moves[index]
		#This works so best way to continue from here is to make if statements that lead to functions
		#if active_player.hero_command_deck.special_moves[index] == move name here:
		#	move_name()
		menu_transition("target")
	if index == choice_options.size() :
		menu_transition("base")

func item_menu(index: int):
	if index == 0:
		pass
	if index == 1:
		pass
	if index == 2:
		menu_transition("base")

func target_menu(index: int):
	if index != targets.size():
		process_attack(action, targets[index])
	if index == targets.size():
		menu_transition(last_menu)

func process_attack(action: String, targets: Player):
	if action == "physical":
		active_player.hero_stats.physical(targets)
	if action == "distance":
		active_player.hero_stats.distance(targets)
