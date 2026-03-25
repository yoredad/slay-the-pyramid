extends Node2D

const CARD_WIDTH = 150
const HAND_Y_POSITION = 700
const DEFAULT_CARD_SPEED = 0.1

var playerHand = []
var centerScreenX 
var centerScreenY
var cardManRef

var slotRef
var deckRef

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centerScreenX = get_viewport().size.x / 2
	slotRef = $"../CardSlot"
	deckRef = $"../Deck"
	cardManRef = $"../CardManager"

func addCardToHand(card, speed):
	if card not in playerHand:
		if !card.inPyramid:
			card.position = deckRef.position	
		card.handPosition = slotRef.position
		card.inPlay = true
		card.inPyramid = false
		if playerHand.size() > 0:
			var currentCard = playerHand.get(0)
			if currentCard:
				playerHand.erase(currentCard)
				currentCard.get_node("Attack").visible = false
				currentCard.z_index=-1
				cardManRef.destroyCard(currentCard)
			
		playerHand.insert(0, card)
		slotRef.get_node("DashedBorder").visible = false
		slotRef.get_node("FireBorder").visible = true
		animateCardToPosition(card, card.handPosition, DEFAULT_CARD_SPEED)
	
#		updateHandPositions(speed)
#	else:
#		animateCardToPosition(card, card.handPosition, DEFAULT_CARD_SPEED)
	
func updateHandPositions(speed):
	for i in range(playerHand.size()):
		var card = playerHand[i]
		var newPosition = Vector2(calculateCardPosition(i), HAND_Y_POSITION)
		card.handPosition = newPosition
		animateCardToPosition(card, newPosition, speed)
		
func calculateCardPosition(idx):
	var totalWidth = (playerHand.size()-1) * CARD_WIDTH
	var xOffset = centerScreenX + idx * CARD_WIDTH - totalWidth / 2 
	return xOffset
			
	
func animateCardToPosition(card, newPosition, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", newPosition, speed)
	
func removeCardFromHand(card):
	if card in playerHand:
		playerHand.erase(card)
		updateHandPositions(DEFAULT_CARD_SPEED)

func resetState():
	for card in playerHand: # i is the key
		card.free() # free the card object
	playerHand.clear() # remove the cards from the array
	slotRef.get_node("DashedBorder").visible = true
	slotRef.get_node("FireBorder").visible = false
	
func activeCardWins(card):
	if playerHand.size() > 0:
		var currentCard = playerHand.get(0)
		if currentCard:	
			# check option for hard mode
			if Settings.greaterThan:
				if currentCard.attack > card.attack:
					return true
				# card is an ace then special rule allows 2 to beat it
				elif card.attack == 14 and currentCard.attack == 2:
					return true				
			else:
				if currentCard.attack >= card.attack:
					return true
				# card is an ace then special rule allows 2 to beat it
				elif card.attack == 14 and currentCard.attack == 2:
					return true
	return false
			
