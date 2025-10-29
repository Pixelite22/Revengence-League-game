extends ItemList

signal turn_ended

var menu := "base"
var last : String
var menu_options = ["base", "attack", "special", "items", "target"]
var active_player : Player

func _ready() -> void:
	clear()
	add_item("Attack", null, true)
	add_item("Special", null, true)
	add_item("Defend", null, true)
	add_item("Items", null, true)
	add_item("Run", null, true)
	add_item("Skip Turn", null, true)

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
		add_item("Special 1", null, true)
		add_item("Special 2", null, true)
		add_item("Back", null, true)
	if new == "items":
		add_item("Item 1", null, true)
		add_item("Item 2", null, true)
		add_item("Back", null, true)

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
		turn_ended.emit()

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
	if index == 2:
		menu_transition("base")

func item_menu(index: int):
	if index == 0:
		pass
	if index == 1:
		pass
	if index == 2:
		menu_transition("base")
