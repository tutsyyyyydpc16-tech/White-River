extends Area3D

var opened = false

func ai_enable_door(body):
	if body.name == "inimigo" and !$Abre_Fecha.current_animation != "close" and $Abre_Fecha.current_animation != "open":
		opened = true
		$Abre_Fecha.play("Abre")
			
func ai_disable_door(body):
	if body.name == "inimigo" and !$Abre_Fecha.current_animation != "close" and $Abre_Fecha.current_animation != "open":
		opened = false
		$Abre_Fecha.play("Fecha")

func toggle_normal_door():
	if $Abre_Fecha.current_animation != "open" and $Abre_Fecha.current_animation != "close":
		opened = !opened
		if !opened:
			$Abre_Fecha.play("Fecha")
		if opened:
			$Abre_Fecha.play("Abre")
			
func interagir():
	toggle_normal_door()
