class_name VentScrewInteraction
extends AbstractInteraction

"""
VentScrewInteraction handles the screws holding a vent panel in place.
The player must have a matching item (the Screwdriver) equipped and use it
on the screws to loosen them. Once loosened, the screws remove themselves
and set Global.parafuso_solto, which the vent trapdoor checks before opening.
"""

## Item name that must be equipped to loosen these screws (matches ItemData.item_name)
@export var required_item_name: String = "Screwdriver"

## Sound effect played when the screws are successfully loosened
@export var success_sound_effect: AudioStreamOggVorbis

func use_item(item_data: ItemData) -> bool:
	if item_data == null or item_data.item_name != required_item_name:
		return false

	Global.parafuso_solto = true

	if success_sound_effect:
		var audio_player := AudioStreamPlayer3D.new()
		audio_player.stream = success_sound_effect
		get_tree().current_scene.add_child(audio_player)
		audio_player.global_transform = object_ref.global_transform
		audio_player.finished.connect(audio_player.queue_free)
		audio_player.play()

	# Remove the screws (and their mesh/collision) from the world now that they're loose
	object_ref.queue_free()
	return true
