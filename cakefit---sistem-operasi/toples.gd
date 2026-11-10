extends Panel

signal diletakkan(jar, data)

func atur(nama: String, kapasitas: int) -> void:
	size = Vector2(200, 60 + kapasitas * 0.35)
	$NamaLabel.text = nama + " (%d MB)" % kapasitas
	atur_sisa(kapasitas)

func atur_sisa(sisa: int) -> void:
	$SisaLabel.text = "Sisa: %d MB" % sisa

func _can_drop_data(_pos, data) -> bool:
	return data is Dictionary and data.has("ukuran")

func _drop_data(_pos, data) -> void:
	diletakkan.emit(self, data)
