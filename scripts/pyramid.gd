extends Node

var pyramid = [7] 
var rowPos = 7

const START_POS_X = 350 # starting pos row 7
const START_POS_Y = 550 # top of pyramid
const CARD_DRAW_SPEED = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resetPyramid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addCard(card):
	var cells = pyramid.get(rowPos - 1)
	var maxCells = rowPos 
	if cells != null:
		if(cells.size() >= maxCells):
			rowPos -= 1 # decrement
			cells = pyramid.get(rowPos - 1) # get next rows cells
		card.inPyramid = true
		card.row = rowPos
		card.cell = cells.size()
		card.z_index = (8 - rowPos) * 2
		card.get_node("cardImage").z_index = (8 - rowPos) * 2
		card.get_node("Attack").z_index = (8 - rowPos) * 2
		card.get_node("CardBackImage").z_index = ((8 - rowPos) * 2) + 1
		if Settings.faceUp:
			card.faceUp()
		else:
			card.faceDown()
		cells.insert(cells.size(), card) # insert at end of array
		var newPosition = Vector2(calculateCardPosX(rowPos, cells.size()), calculateCardPosY(rowPos))
		animateCardToPosition(card, newPosition, CARD_DRAW_SPEED)

func animateCardToPosition(card, newPosition, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", newPosition, speed)	
	
func calculateCardPosX(row, cell):
	var xPos = START_POS_X + ((7 - row) * 75) + ((cell - 1) * 150)
	return xPos

func calculateCardPosY(row):
	var yPos = START_POS_Y + ((row -1) * 50) - 200
	return yPos
	
func resetState():
	resetPyramid()
	
func resetPyramid():
	rowPos = 7
	pyramid = [7] 
	var cells
	for i in range(1, 8):
		cells = []
		pyramid.insert(0, cells)

#check for uncovered cards and flip them
func checkUncovered():
	var hasCards = false
	var cells
	for i in range(0, 7):
		cells = pyramid[i]
		for j in range(0, cells.size()):
			var card = cells[j]
			#check row aboe
			if card:
				if card.inPyramid:
					hasCards = true
				if !card.isFaceUp and isUncovered(card):
					card.faceUp()
	if !hasCards:
		print("player wins!")
		$"..".toggleExit()
		
func isUncovered(card):
	var checkRow = card.row - 2
	if checkRow < 0: # first row
		return true
	var maxCells = getMaxCellsFromRow(checkRow)		
	var cells = pyramid[checkRow]
	var checkCell = card.cell - 1
	var c1 = null
	if checkCell >= 0:
		c1 = cells[checkCell]
	checkCell = card.cell 
	var c2 = null
	if checkCell < maxCells: # last cell won't have a c2
		c2 = cells[checkCell]
	if (c1 == null or !c1.inPyramid) and (c2 == null or !c2.inPyramid):
		return true
		
	
func getMaxCellsFromRow(row):
	row += 1
	return row
	
func flipFirstCard():
	var cells = pyramid[0]
	var card = cells[0]
	if card:
		card.faceUp()
	
