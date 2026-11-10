extends Control

const SAVE_PATH = "user://settings.cfg"

@onready var volume_slider: HSlider = $VolumeSlider
@onready var button_save: TextureButton = $ButtonSave


func _ready():
	# Menghubungkan slider dan tombol
	volume_slider.value_changed.connect(_on_volume_changed)
	button_save.pressed.connect(_on_save_pressed)

	# Membaca pengaturan yang tersimpan
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)

	if error == OK:
		volume_slider.value = config.get_value("audio", "volume", 50.0)
	else:
		volume_slider.value = 50.0

	apply_volume(volume_slider.value)


func _on_volume_changed(value: float):
	apply_volume(value)


func apply_volume(value: float):
	var bus = AudioServer.get_bus_index("Master")

	if bus == -1:
		return

	AudioServer.set_bus_mute(bus, value <= 0)

	if value > 0:
		AudioServer.set_bus_volume_db(
			bus,
			linear_to_db(value / 100.0)
		)


func _on_save_pressed():
	var config = ConfigFile.new()

	config.set_value("audio", "volume", volume_slider.value)

	var error = config.save(SAVE_PATH)

	if error == OK:
		print("Settings berhasil disimpan!")
	else:
		print("Gagal menyimpan settings!")
