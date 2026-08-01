extends OmniLight3D

var timer = 0.0

func _process(delta: float) -> void:
	timer -= delta
	
	if timer <= 0:
		timer = randf_range(0.05, 0.2)
		
		if randf() < 0.8:
			light_energy = 0.5
		else:
			light_energy = 0.1
	
