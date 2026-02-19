extends Control



@onready var card_scene : PackedScene = preload("res://interfaces/items/item_card.tscn")
@onready var resume_button : Button = get_node('Resume_Button')
@onready var title_label : Label = get_node('Title_Label')
@onready var cards_container : HBoxContainer = get_node('%Cards_Container')

@onready var title_pos = title_label.position
@onready var resume_pos = resume_button.position

# ITEM NAME, ITEM DESCRIPTION
var items = [
	['Café', 'Aumente a velocidade de movimento e ataque em 30% por 3s. Consumível'],
	['Cachorro', 'Companheiro canino, morde uma lição aleatória a cada 2s.'],
	['Maçã', 'Aumente a velocidade de movimento e ataque em 30% por 3 segundos. Consumível'],
	['Carimbada', 'Acerte o chão empurrando inimigos para longe. Ataque aéreo'],
	['Clipe de Papel', 'Lance um clipe que agrupa inimigos próximos. Ataque'],
	['Grampeador', 'Atira grampos em volta a cada 3s.']
	#'spin'= ['Giro', 'Acerte o chão empurrando inimigos para longe. Ataque aéreo']
]
var cards = []

signal card_selected
signal ended

func _ready() -> void:
	visible = false

func enter() -> void:
	visible = true
	resume_button.disabled = false
	items.shuffle()
	for n in 3:
		build_card(n)
	
	
	title_pos = title_label.position
	resume_pos = resume_button.position
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	
	title_label.position.y -= 250
	tween.tween_property(title_label, "position", title_pos, 0.2)
	
	cards_container.modulate = Color(1, 1, 1, 0)
	tween.tween_property(cards_container, "modulate", Color(1, 1, 1, 1), 0.5)
	
	resume_button.position.x += 600
	tween.tween_property(resume_button, "position", resume_pos, 0.4)


func build_card(card_number : int) -> void:
	var card_id = items[card_number]
	var new_card = card_scene.instantiate()
	cards_container.add_child(new_card)
	new_card.name_label.text = card_id[0]
	var card_texture = load("res://interfaces/items/Icons/" + card_id[0] + ".png")
	new_card.icon_tex.texture = card_texture
	new_card.description_label.text = card_id[1]
	
	new_card.selected.connect(item_selected)
	
	cards.append(new_card)

func find_item_selected(item_name) -> int:
	for i in items.size():
		if items[i][0] == item_name:
			return i
	return -1

func item_selected(item) -> void:
	# remove the card selected from selection list
	items.remove_at(find_item_selected(item.name_label.text))
	
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	
	for card in cards_container.get_children():
		if card != item:
			card.disabled = true
			tween.tween_property(card, 'modulate', Color(1, 1, 1, 0), 0.15)
	
	resume_button.disabled = true
	
	await get_tree().create_timer(1).timeout
	
	exit()

func exit() -> void:
	visible = false
	for child in cards_container.get_children():
		child.queue_free()
	ended.emit()

func _on_resume_button_pressed() -> void:
	exit()
