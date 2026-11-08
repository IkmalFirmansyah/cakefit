extends Control

func _on_play_button_pressed() -> void:
	Game.level_sekarang = 0
	get_tree().change_scene_to_file("res://game.tscn")
