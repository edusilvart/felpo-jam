extends Button


@onready var name_label : Label = get_node('Name')
@onready var icon_tex : TextureRect = get_node('Icon')
@onready var description_label : Label = get_node('Description')

signal selected

func _on_pressed() -> void:
	selected.emit(self)
