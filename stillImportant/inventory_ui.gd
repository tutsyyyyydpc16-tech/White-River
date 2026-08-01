extends Control#inventário

func _ready() -> void:
	if Global.tem_mapa:
		$Mapa.visible = true
	else:
		$Mapa.visible = false
		
	if Global.tem_paper1:
		$paper_ui.visible = true
	else:
		$paper_ui.visible = false
