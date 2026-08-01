extends CanvasLayer

@onready var audio = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.bus = "SFX"
	
