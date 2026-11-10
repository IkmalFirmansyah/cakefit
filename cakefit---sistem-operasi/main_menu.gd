extends Control

func _on_play_button_pressed() -> void:
	Game.level_sekarang = 0
	get_tree().change_scene_to_file("res://game.tscn")


func _on_settings_button_pressed() -> void:
	print("Settings button berhasil diklik!")
	get_tree().change_scene_to_file("res://settings.tscn")
