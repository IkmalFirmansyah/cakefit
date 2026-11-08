extends Panel

var nama := "P1"
var ukuran := 96

func atur(n: String, u: int) -> void:
	nama = n
	ukuran = u
	$Label.text = nama + "\n" + str(ukuran) + "MB"

func _get_drag_data(_pos):
	var preview = Label.new()
	preview.text = "%s (%d MB)" % [nama, ukuran]
	set_drag_preview(preview)
	return {"nama": nama, "ukuran": ukuran, "sumber": self}
