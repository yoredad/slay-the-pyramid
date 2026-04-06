extends Node2D

const CARD_WIDTH = 150
const HAND_Y_POSITION = 700
const DEFAULT_CARD_SPEED = 0.1

var playerHand = []
var aceHand = []
var centerScreenX 
var centerScreenY
var cardManRef

var cardSlot
var aceSlot
var deckRef
var activeSlot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centerScreenX = get_viewport().size.x / 2
	cardSlot = $"../CardSlot"
	aceSlot = $"../AceSlot"
	deckRef = $"../Deck"
	cardManRef = $"../CardManager"

func addCardToHand(card, speed):
	if card not in playerHand:
		if !card.inPyramid:
			card.position = deckRef.position	
		card.handPosition = cardSlot.position
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
		toggleActiveSlot("CardSlot")
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
	cardSlot.get_node("DashedBorder").visible = true
	cardSlot.get_node("FireBorder").visible = false
	if(Settings.aceInTheHole):
		aceSlot.get_node("DashedBorder").visible = true
		aceSlot.get_node("FireBorder").visible = false	
	
func activeCardWins(card):
	var wins :bool = false
	var currentCard = null
	var isAceCard = false
	if(activeSlot && activeSlot.name=="CardSlot"):
		if playerHand.size() > 0:
			currentCard = playerHand.get(0)
	else:
		if aceHand.size() > 0:
			isAceCard = true
			currentCard = aceHand.get(0)
	if currentCard:	
		# check option for hard mode
		if Settings.greaterThan:
			if currentCard.attack > card.attack:
				wins = true
			# card is an ace then special rule allows 2 to beat it
			elif card.attack == 14 and currentCard.attack == 2:
				wins = true				
		else:
			if currentCard.attack >= card.attack:
				wins = true
			# card is an ace then special rule allows 2 to beat it
			elif card.attack == 14 and currentCard.attack == 2:
				wins = true
	if wins:
		$"..".currentStreak += 1
		if isAceCard:
			if currentCard:
				aceHand.erase(currentCard)
				currentCard.get_node("Attack").visible = false
				currentCard.z_index=-1
				cardManRef.destroyCard(currentCard)			
	return wins
			
func addCardToAceSlot(card, speed):
	card.position = deckRef.position	
	card.handPosition = aceSlot.position
	card.inPlay = true
	card.inAceSlot = true
	card.inPyramid = false
	aceHand.insert(0, card)
	aceSlot.get_node("DashedBorder").visible = false
	aceSlot.get_node("FireBorder").visible = true
	animateCardToPosition(card, card.handPosition, DEFAULT_CARD_SPEED)

func removeCardFromAceSlot():
	if aceHand.size() > 0:
		var currentCard = aceHand.get(0)
		if currentCard:
			aceHand.erase(currentCard)
			currentCard.get_node("Attack").visible = false
			currentCard.z_index=-1
			cardManRef.destroyCard(currentCard)	

func toggleActiveSlot(name):
	if(name=="CardSlot"):
		if(playerHand.size()>0):
			cardSlot.get_node("FireBorder").visible = true
			aceSlot.get_node("FireBorder").visible = false
			activeSlot = cardSlot
	elif(name=="AceSlot"):
		if aceHand.size() > 0:
			cardSlot.get_node("FireBorder").visible = false
			aceSlot.get_node("FireBorder").visible = true		
			activeSlot = aceSlot
