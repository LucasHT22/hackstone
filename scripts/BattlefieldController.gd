class_name BattlefieldController
extends "res://scripts/CardGroupController.gd"

var desired_total_width : float = 20
var current_drag_index : int
@export var opponent_battlefield : BattlefieldController

func insert_card(card: Node3D, index: int, global_position: Vector3) -> void:
	super.insert_card(card, index, global_position)	
	
	for neighbor in self.managed_cards:
		neighbor.on_neighbors_changed()
		
	for neighbor in opponent_battlefield.managed_cards:
		neighbor.on_enemy_neighbors_changed()

	card.on_entered_play()

func take_card(index: int) -> Node3D:
	var card = super.take_card(index)
	card.on_exited_play()
	for neighbor in self.managed_cards:
		neighbor.on_neighbors_changed()
	for neighbor in opponent_battlefield.managed_cards:
		neighbor.on_enemy_neighbors_changed()
	return card

func get_desired_position(index: int) -> Vector3:
	var num_cards = get_cards_len()

	if current_drag_point != null:
		num_cards += 1	
		current_drag_index = card_index_of_point(current_drag_point)
		if current_drag_index <= index:
			index += 1

	desired_total_width = 3.0 * float(num_cards)

	var width_per_card = float(desired_total_width) / float(num_cards)
	var absolute_x_offset = width_per_card * float(index)
	var centered_x_offset = -desired_total_width/2 + absolute_x_offset + width_per_card/2	
	
	return Vector3(centered_x_offset, 0, -0.05*index)

func get_desired_rotation(index: int):
	return Basis.IDENTITY.rotated(Vector3.UP, deg_to_rad(0.1 * float(index)))

func card_index_of_point(point):
	# NOTE - this 15 business here is really raunchy, only works by happenstance
	# this could definitely use a brush-up
	if point.x < -15: return 0
	if point.x > 15: return get_cards_len()
	var min : float = -15
	var max : float = 15
	var width_per_card = float(desired_total_width) / float(get_cards_len()+1)
	var normalized_value = (point.x - min) / (max - min)
	var absolute_x = normalized_value * float(desired_total_width)
	return int(absolute_x / width_per_card)
