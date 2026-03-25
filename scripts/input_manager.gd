extends Node2D

signal leftMouseClicked
signal leftMouseButtonReleased

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_ACE_OPT = 3
const COLLISION_MASK_DECK = 4
const COLLISION_MASK_OPT_OK = 65
const COLLISION_MASK_FACE_OPT = 129
const COLLISION_MASK_OPT_CANCEL = 130
const COLLISION_MASK_GT_OPT = 131
const COLLISION_MASK_RETIRE = 136
const COLLISION_MASK_EXIT = 16
const COLLISION_MASK_START = 32
const COLLISION_MASK_OPTIONS = 33

var cardManagerRef
var deckRef
var mainRef
var optionsRef
var playerHandRef

func _ready() -> void:
	cardManagerRef = $"../CardManager"
	deckRef = $"../Deck"
	mainRef = $".."
	optionsRef = $"../Options"
	playerHandRef = $"../PlayerHand"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("leftMouseClicked")
			raycastAtCursor()
		else:
			emit_signal("leftMouseButtonReleased")
	
func raycastAtCursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var resultCollisionMask = result[0].collider.collision_mask
		print(resultCollisionMask)
		if resultCollisionMask == COLLISION_MASK_CARD:
			# card clicked
			var cardFound = getTopCard(result) # result[0].collider.get_parent()
			if cardFound:
				if cardFound.inPlay:
					print("in play " + cardFound.name + " " + str(cardFound.attack))
				if cardFound.inPyramid:
					print("in pyramid at " + str(cardFound.row) + " : " + str(cardFound.cell))
					if $"../Pyramid".isUncovered(cardFound) && cardFound.isFaceUp:
						# cardManagerRef.destroyCard(cardFound)
						if playerHandRef.activeCardWins(cardFound):
							playerHandRef.addCardToHand(cardFound, playerHandRef.DEFAULT_CARD_SPEED)
							$"../Pyramid".checkUncovered()
					#else :	
					#	cardFound.flipCard()
					# If am I covered? pass
					# else
					# if face down, flip face up
					# if face up evaluate against the active card
#				cardManagerRef.start_drag(cardFound)
		elif resultCollisionMask == COLLISION_MASK_DECK:
			# Deck clicked
			deckRef.drawCardFromDeck()
		elif resultCollisionMask == COLLISION_MASK_EXIT:
			if mainRef.gameState == mainRef.GAME:
				mainRef.returnToLanding()
			else:
				get_tree().quit(0)	
		elif resultCollisionMask == COLLISION_MASK_RETIRE:
			mainRef.returnToLanding()
		elif resultCollisionMask == COLLISION_MASK_START:
			mainRef.initializeGame()		
		elif resultCollisionMask == COLLISION_MASK_ACE_OPT:
			optionsRef.setOption(optionsRef.OPTION_ACE)
		elif resultCollisionMask == COLLISION_MASK_FACE_OPT:
			optionsRef.setOption(optionsRef.OPTION_FACE)
		elif resultCollisionMask == COLLISION_MASK_GT_OPT:
			optionsRef.setOption(optionsRef.OPTION_GT)
		elif resultCollisionMask == COLLISION_MASK_OPT_CANCEL:
			if !mainRef.gameState == mainRef.GAME:
				mainRef.returnToLanding()
				optionsRef.visible = false
				optionsRef.hideButtons()
		elif resultCollisionMask == COLLISION_MASK_OPT_OK:
			if !mainRef.gameState == mainRef.GAME:
				optionsRef.saveOptions()
				mainRef.returnToLanding()
				optionsRef.visible = false
				optionsRef.hideButtons()
		elif resultCollisionMask == COLLISION_MASK_OPTIONS:
			mainRef.hideButtons()
			optionsRef.setOptionsFromConfig()
			optionsRef.visible = true
			optionsRef.showButtons()

# Godot returns all overlapping colliders, but in no guaranteed order.
# You can sort them yourself by z‑index:
func getTopCard(results):
	# Sort by the parent node's z_index
	results.sort_custom(func(a, b):
		return a.collider.get_parent().z_index > b.collider.get_parent().z_index)
	var top = results[0].collider.get_parent()
	return top	
