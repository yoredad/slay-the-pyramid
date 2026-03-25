extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const DEFAULT_CARD_SPEED = 0.1

var screen_size
var card_being_dragged
var is_hovering_over_card
var playerHandReference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	playerHandReference = $"../PlayerHand"
	$"../InputManager".connect("leftMouseButtonReleased", onLeftClickReleased)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		#var mouse_pos = get_global_mouse_position()
		#var mouse_pos = get_viewport().get_mouse_position()
		var mouse_pos = card_being_dragged.get_parent().get_local_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x,0,screen_size.x), clamp(mouse_pos.y,0,screen_size.y))

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)

func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	var cardSlotFound = raycast_check_for_card_slot()
	if cardSlotFound and not cardSlotFound.cardInSlot:
		#card dropped into empty slot
		playerHandReference.removeCardFromHand(card_being_dragged)
		card_being_dragged.position = cardSlotFound.position
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		cardSlotFound.cardInSlot = true
		card_being_dragged = null
	else:
		playerHandReference.addCardToHand(card_being_dragged, DEFAULT_CARD_SPEED)
		card_being_dragged = null

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null


func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null
	
				
func getCardWithHighZIndex(cards):
	var highZCard = cards[0].collider.get_parent()
	var highZIndex = highZCard.z_index
	#start at second occurance (1) since we already got the first card above
	if cards.size() > 1:
		for i in range(1, cards.size()):
			var curCard = cards[i].collider.get_parent()
			if curCard.z_index > highZIndex:
				highZCard = curCard
				highZIndex = highZCard.z_index
	return highZCard
	
func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	
func on_hovered_over_card(card):
	if !is_hovering_over_card:
		is_hovering_over_card = true
		highlight_card(card, true)
		
	
func on_hovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card, false)
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_over_card = false
	
	
func highlight_card(card, hovered):
	if hovered:
		pass
#		card.scale = Vector2(1.05, 1.05)
#		card.z_index = 2
#		var rt = card.get_node("Attack")
#		rt.scale = Vector2(1.05, 1.55)
#		rt.z_index = 2
	else:
		pass
#		card.scale = Vector2(1.00, 1.00)
#		card.z_index = 1
#		var rt = card.get_node("Attack")
#		rt.scale = Vector2(1.50, 1.50)
#		rt.z_index = 1
		
func onLeftClickReleased():
	if card_being_dragged:
		finish_drag()
	
func resetState():
	card_being_dragged = null
	is_hovering_over_card = false	
	playerHandReference.resetState()
	for child in get_children():
		child.free()
		
func destroyCard(card):
	for child in get_children():
		if child.name.begins_with(card.name):
			child.queue_free()
			break
