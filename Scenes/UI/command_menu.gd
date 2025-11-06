extends ItemList

signal turn_ended

var menu := "base"
var last : String
var menu_options = ["base", "attack", "special", "items", "target"]
var active_player : Player
var choice_options : Array = []

func _ready() -> void:
	clear()
	add_item("Attack", null, true)
	add_item("Special", null, true)
	add_item("Defend", null, true)
	add_item("Items", null, true)
	add_item("Run", null, true)
	add_item("Skip Turn", null, true)

func fill_choice_options():
	if active_player:
		choice_options.clear()
		for options in active_player.hero_command_deck.special_moves:
			choice_options.append(options)

func _on_item_selected(index: int) -> void:
	if menu == "base":
		base_menu(index)
	if menu == "attack":
		attack_menu(index)
	if menu == "special":
		special_menu(index)
	if menu == "items":
		item_menu(index)

func menu_transition(new_menu):
	last = menu
	menu = new_menu
	change_options(menu)

func change_options(new):
	clear()
	if new == "base":
		add_item("Attack", null, true)
		add_item("Special", null, true)
		add_item("Defend", null, true)
		add_item("Items", null, true)
		add_item("Run", null, true)
		add_item("Skip Turn", null, true)
	if new == "attack":
		if active_player.hero_command_deck:
			add_item(active_player.hero_command_deck.attack_type.Physical, null, true)
			add_item(active_player.hero_command_deck.attack_type.Distance, null, true)
			add_item("Back")
		else:
			add_item("Physical Option", null, true)
			add_item("Distance Option", null, true)
			add_item("Back", null, true)
	if new == "special":
		if active_player.hero_command_deck:
			for moves in active_player.hero_command_deck.special_moves:
				add_item(moves, null, true)
			add_item("Back", null, true)
		else:
			add_item("Special 1", null, true)
			add_item("Special 2", null, true)
			add_item("Back", null, true)
	if new == "items":
		add_item("Item 1", null, true)
		add_item("Item 2", null, true)
		add_item("Back", null, true)


#From here on I should find a way to make these functions more dynamic since the moves can vary from 
#player to player but the back button always needs to stay in the same spot at the end.
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
	if index == 0:
		pass
	if index == 1:
		pass
	if index == 2:
		menu_transition("base")

func special_menu(index: int):
	if index == 0:
		pass
	if index == 1:
		pass
	if index == choice_options.size() :
		menu_transition("base")

func item_menu(index: int):
	if index == 0:
		pass
	if index == 1:
		pass
	if index == 2:
		menu_transition("base")
