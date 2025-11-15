extends Control

signal target_menu_opened

func _on_command_menu_target_menu_opened() -> void:
	target_menu_opened.emit()
