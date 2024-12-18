extends "res://scripts/CardGroupController.gd"

func insert_card(card: Node3D, index: int, global_position: Vector3) -> void:
	super.insert_card(card, index, global_position)	
	card.show_power_toughness(false)
	
func take_card(index: int) -> Node3D:
	var card = super.take_card(index)
	card.on_drawn()
	return card
	
func get_desired_position(index: int) -> Vector3:
	return Vector3(-0.001 * float(index), 0.001 * float(index), -0.03 * float(index))

func get_desired_rotation(index: int):
	return Basis.IDENTITY.rotated(Vector3.RIGHT, deg_to_rad(180)).rotated(Vector3.FORWARD, deg_to_rad(180))
