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

func fill_choice_options(type):
	if active_player: #If active_player isn't null
		choice_options.clear() #Clear the choice_options array
		if type == "base": #If menu is base, add the correct options
			choice_options.append("Attack")
			choice_options.append("Special")
			choice_options.append("Defend")
			choice_options.append("Items")
			choice_options.append("Run")
			choice_options.append("Skip Turn")
#			for option in choice_options:
#				add_item(choice_options[option], null, true)
		if type == "attack": #If it is attack
			for options in active_player.hero_command_deck.attack_type: #Loop through the options in the command deck
				choice_options.append(options) #and add them to the menu
		if type == "special": #If special
			for options in active_player.hero_command_deck.special_moves: # for options in the current players command deck
				choice_options.append(options) #Append those options to the choice_options array
		if type == "items":
			pass
		if type == "target":
			for enemies in targets: #For enemies in the target array
				choice_options.append(enemies) #Add the targets to the menu

#Direct to the correct function based on choice
func _on_item_selected(index: int) -> void:
	#Each if statement reads if a menu is "insert menu here" and has an index of 0 or more
	#This is due to 0 being the first number written into index from a click, and -1 being the number
	#Used to stop "menu bleed" which is what I am calling the phenomena where you click one option and are
	#Shot through all menus due to the mouse still being clicked for milliseconds after the selection
	if menu == "base" and index >= 0: #So for example, if the menu is the base menu and the index is viable
		base_menu(index) #Send the index to the base_menu function so it can select the option wanted
		index = -1 #and then set index to an unviable value so we don't bleed the selection to the next one
	if menu == "attack" and index >= 0:
		attack_menu(index)
		index = -1
	if menu == "special" and index >= 0:
		special_menu(index)
		index = -1
	if menu == "items" and index >= 0:
		item_menu(index)
		index = -1
	if menu == "target" and index >= 0:
		target_menu(index)
		index = -1

#menu transition function
func menu_transition(new_menu):
	last_menu = menu #Set the last to the menu for when a back option exists
	menu = new_menu #Set menu to the new_menu value
#	mouse_lag()
	change_options(menu) #Call change options functoin


#Handles a most of the menu logic
func change_options(new):
	clear() #Start by clearing menu
	if new == "base": #If the new value is base, add these items 
		fill_choice_options("base")
		add_item("Attack", null, true)
		add_item("Special", null, true)
		add_item("Defend", null, true)
		add_item("Items", null, true)
		add_item("Run", null, true)
		add_item("Skip Turn", null, true)
	if new == "attack": #If the new value is attack
		fill_choice_options("attack")
		if active_player.hero_command_deck: #and there is an active player
			add_item(active_player.hero_command_deck.attack_type.Physical, null, true) #Add the physical equivalent attack
			add_item(active_player.hero_command_deck.attack_type.Distance, null, true) #Add the distance equivalent attack
			add_item("Back")
		else: # and if there isn't an active player, add these placeholders
			add_item("Physical Option", null, true)
			add_item("Distance Option", null, true)
			add_item("Back", null, true)
	if new == "special": #If special
		fill_choice_options("special")
		if active_player.hero_command_deck: #and there is a player
			for key in active_player.hero_command_deck.special_moves.keys(): #for each move in the active player command deck
				add_item(active_player.hero_command_deck.special_moves[key], null, true) #add them to the menu
			add_item("Back", null, true) #and add back
		else: #else placeholder
			add_item("Special 1", null, true)
			add_item("Special 2", null, true)
			add_item("Back", null, true)
	if new == "items": #if items (placeholders for now)
		fill_choice_options("items")
		add_item("Item 1", null, true)
		add_item("Item 2", null, true)
		add_item("Back", null, true)
	if new == "target":
		fill_choice_options("target")
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

func target_menu(index: int): #Target Menu function
	if index != targets.size(): #If the chosen option is anything but the final one
		if action == "physical" or action == "distance":
			process_attack(action, targets[index]) #send the action set earlier in either special_menu or attack_menu and the chosen target to the process attack function
		if action == "Giga Punch":
			active_player.hero_stats.giga_punch(targets[index])
			attack_turn_end()
			
	if index == targets.size(): #if the chosen option is the final one.  
		menu_transition(last_menu) #Transition to whatever the last menu is

func process_attack(action: String, targets: Player):
	if action == "physical": #if action is set to "physical"
		active_player.hero_stats.physical(targets) #call the physical function from the active player's hero_stats
	if action == "distance": #if action is set to "distance"
		active_player.hero_stats.distance(targets) #call the distance function from the active player's hero_stats
	
	attack_turn_end()

func attack_turn_end():
	menu_transition("base") #Send menu back to the basic menu
	turn_ended.emit(false) #Emit turn end to Start next players turn

func disable_menus():
	for item in range(get_item_count()):
		set_item_disabled(item, true)

func enable_menus():
	for item in range(get_item_count()):
		set_item_disabled(item, false)
