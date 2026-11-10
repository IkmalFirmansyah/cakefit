class_name Game
extends Control

static var level_sekarang := 0

const LEVELS = [
	{"fase": ["first"], "toples": [200, 400, 300], "proses": [150, 250, 100]},
	{"fase": ["best"], "toples": [300, 150, 500, 250], "proses": [120, 200, 140, 300]},
	{"fase": ["worst"], "toples": [400, 200, 600, 300], "proses": [100, 250, 130, 200, 120]},
	{"fase": ["first", "best"], "toples": [350, 150, 450, 250, 550], "proses": [100, 200, 300, 120, 180, 220]},
	{"fase": ["first", "best", "worst"], "toples": [300, 500, 200, 400, 600], "proses": [110, 250, 80, 180, 320, 140, 200]},
]
const NAMA = {"first": "First Fit", "best": "Best Fit", "worst": "Worst Fit"}
const JAR = preload("res://toples.tscn")
const CUPCAKE = preload("res://cupcake.tscn")

var fase := 0
var sisa := []
var daftar_jar := []
var nomor_proses := 0
var cupcake_aktif = null

func data() -> Dictionary:
	return LEVELS[level_sekarang]

func algo() -> String:
	return data()["fase"][fase]

func cari_toples(a: String, ukuran: int) -> int:
	var hasil := -1
	for i in sisa.size():
		if sisa[i] < ukuran:
			continue
		if a == "first":
			return i
		if hasil == -1:
			hasil = i
		elif a == "best" and sisa[i] < sisa[hasil]:
			hasil = i
		elif a == "worst" and sisa[i] > sisa[hasil]:
			hasil = i
	return hasil

func _ready() -> void:
	$TombolReset.pressed.connect(func(): get_tree().reload_current_scene())
	$TombolMenu.pressed.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"))
	$PopupMenang.hide()
	$PopupMenang/PanelPopup/LanjutButton.pressed.connect(_on_lanjut)
	var toples = data()["toples"]
	var lebar_total = toples.size() * 240 - 40
	var awal = (1280 - lebar_total) / 2
	for i in toples.size():
		var jar = JAR.instantiate()
		add_child(jar)
		jar.position = Vector2(awal + i * 240, 200)
		jar.atur("Toples %d" % (i + 1), toples[i])
		jar.position.y = 480 - jar.size.y
		jar.diletakkan.connect(_on_diletakkan)
		daftar_jar.append(jar)
	mulai_fase()

func tampil_popup() -> void:
	var label =$PopupMenang/PanelPopup/SelamatLabel
	var tombol =$PopupMenang/PanelPopup/LanjutButton
	if level_sekarang + 1 >= LEVELS.size():
		label.text = "Selamat!\nSemua Level Selesai"
	else:
		label.text = "Selamat!\nKeLevel Selanjutnya"
		tombol.text = "Lanjut"
	$PopupMenang.show()

func info(pesan: String) -> void:
	$InfoLabel.text = "Level %d - %s\nCupcake %d dari %d\n%s" % [level_sekarang + 1, NAMA[algo()], nomor_proses + 1, data()["proses"].size(), pesan]

func mulai_fase() -> void:
	sisa = data()["toples"].duplicate()
	for i in daftar_jar.size():
		daftar_jar[i].atur_sisa(sisa[i])
	nomor_proses = 0
	tampil_cupcake()
	info("Seret cupcake ke toples yang benar")

func tampil_cupcake() -> void:
	cupcake_aktif = CUPCAKE.instantiate()
	add_child(cupcake_aktif)
	cupcake_aktif.position = Vector2(580, 520)
	cupcake_aktif.atur("P%d" % (nomor_proses + 1), data()["proses"][nomor_proses])

func _on_diletakkan(jar, data_drag) -> void:
	var ukuran = data_drag["ukuran"]
	var benar = cari_toples(algo(), ukuran)
	var tujuan = daftar_jar.find(jar)
	if tujuan != benar:
		info("Salah! Pakai aturan " + NAMA[algo()])
		return
	sisa[tujuan] -= ukuran
	jar.atur_sisa(sisa[tujuan])
	cupcake_aktif.queue_free()
	nomor_proses += 1
	if nomor_proses < data()["proses"].size():
		tampil_cupcake()
		info("Benar!")
	else:
		fase_selesai()

func fase_selesai() -> void:
	fase += 1
	if fase < data()["fase"].size():
		mulai_fase()
	else:
		tampil_popup()

func _on_lanjut() -> void:
	if level_sekarang + 1 < LEVELS.size():
		level_sekarang += 1
		get_tree().reload_current_scene()
	else:
		level_sekarang = 0
		get_tree().change_scene_to_file("res://main_menu.tscn")
