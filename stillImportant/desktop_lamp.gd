extends Node3D

var ligado = true


func interagir():
	ligado = !ligado
	
	if ligado:
		$SpotLight3D.light_energy = 10.0
	else:
		$SpotLight3D.light_energy = 0.0
		
