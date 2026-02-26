extends Control


@onready var fade : ColorRect = get_node('Fade')
@onready var card_scene : PackedScene = preload("res://interfaces/items/item_card.tscn")
@onready var title_label : Label = get_node('Title_Label')
@onready var cards_container : HBoxContainer = get_node('%Cards_Container')

@onready var title_pos = title_label.position

# ITEM NAME, ITEM DESCRIPTION
var items = [
	['Café', 'Aumente a velocidade de movimento e ataque em 30% por 3s.', 'Consumível'],
	['Cachorro', 'Morde uma lição aleatória.', 'Habilidade'],
	['Maçã', 'Cure +2 de vida', 'Consumível'],
	['Carimbada', 'Acerte o chão empurrando inimigos para longe.', 'Habilidade'],
	['Clipe de Papel', 'Lance um clipe que agrupa inimigos próximos.', 'Habilidade'],
	['Rodopio', 'Rodopie girando o carimbo e acertando quem estiver no caminho.', 'Habilidade'],
	['Grampeador', 'Atira 8 grampos em volta.', 'Habilidade']
]
var cards = []

#signal card_selected
signal ended

func _ready() -> void:
	visible = false

func enter() -> void:
	visible = true
	items.shuffle()
	for n in 3:
		build_card(n)
	
	
	title_pos = title_label.position
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	
	title_label.position.y -= 250
	tween.tween_property(title_label, "position", title_pos, 0.2)
	
	cards_container.modulate = Color(1, 1, 1, 0)
	tween.tween_property(cards_container, "modulate", Color(1, 1, 1, 1), 0.5)
	
	fade.color = Color(0, 0, 0, 0)
	tween.tween_property(fade, "color", Color(0, 0, 0, 0.4), 0.3)

func build_card(card_number : int) -> void:
	var card_id = items[card_number]
	var new_card = card_scene.instantiate()
	cards_container.add_child(new_card)
	new_card.name_label.text = card_id[0]
	var card_texture = load("res://interfaces/items/Icons/" + card_id[0] + ".png")
	new_card.icon_tex.texture = card_texture
	new_card.description_label.text = card_id[1]
	new_card.type_label.text = card_id[2]
	
	new_card.selected.connect(item_selected)
	new_card.item_set.connect(item_set)
	
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

func item_set() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(fade, "color", Color(0, 0, 0, 0), 0.3)
	
	await get_tree().create_timer(1).timeout
	exit()

func exit() -> void:
	visible = false
	for child in cards_container.get_children():
		child.queue_free()
	ended.emit()
