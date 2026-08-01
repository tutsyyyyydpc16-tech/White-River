extends RayCast3D

"func check_vision() -> bool:
	var space = get_world_3d().direct_space_state

	var origin = global_position + Vector3(0, 1.5, 0)
	var target = player.global_position + Vector3(0, 1.5, 0)

	var query = PhysicsRayQueryParameters3D.create(origin, target)
	query.exclude = [self]

	var result = space.intersect_ray(query)

	if result and result.collider == player:
		var dist = global_position.distance_to(player.global_position)
		return dist <= sight_distance

	return false"
