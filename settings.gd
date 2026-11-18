class_name settings
extends Control

const SAVE_PATH = "user://settings.cfg"
const DEFAULT_VOLUME = 50.0

@onready var volume_slider: HSlider = $VolumeSlider
@onready var button_save: TextureButton = $ButtonSave


func _ready() -> void:
	volume_slider.min_value = 0
	volume_slider.max_value = 100
	volume_slider.step = 1

	if not volume_slider.value_changed.is_connected(_on_volume_changed):
		volume_slider.value_changed.connect(_on_volume_changed)

	if not button_save.pressed.is_connected(_on_save_pressed):
		button_save.pressed.connect(_on_save_pressed)

	load_settings()


func load_settings() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)

	var saved_volume = DEFAULT_VOLUME

	if error == OK:
		saved_volume = float(config.get_value("audio", "volume", DEFAULT_VOLUME))
	elif error != ERR_FILE_NOT_FOUND:
		print("Gagal membaca settings: ", error)

	saved_volume = clampf(saved_volume, 0.0, 100.0)

	volume_slider.set_value_no_signal(saved_volume)
	apply_volume(saved_volume)

	print("Volume saat game dimulai: ", saved_volume)


func _on_volume_changed(value: float) -> void:
	apply_volume(value)
	save_settings(value)


func apply_volume(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")

	if bus == -1:
		print("Audio bus Master tidak ditemukan!")
		return

	AudioServer.set_bus_mute(bus, value <= 0)

	if value > 0:
		AudioServer.set_bus_volume_db(
			bus,
			linear_to_db(value / 100.0)
		)


func save_settings(value: float) -> void:
	var config = ConfigFile.new()

	config.set_value("audio", "volume", value)

	var error = config.save(SAVE_PATH)

	if error == OK:
		print("Volume berhasil disimpan: ", value)
	else:
		print("Gagal menyimpan settings: ", error)


func _on_save_pressed() -> void:
	save_settings(volume_slider.value)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
