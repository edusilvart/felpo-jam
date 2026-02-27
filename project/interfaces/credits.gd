extends PanelContainer


@export var first_button : Button

signal exit

func _ready() -> void:
	visible = false

func enter() -> void:
	first_button.grab_focus()
	visible = true

func leave() -> void:
	exit.emit()
	visible = false

func _on_corsi_social_pressed() -> void:
	OS.shell_open('https://www.instagram.com/kupts')

func _on_beto_social_pressed() -> void:
	OS.shell_open('https://www.instagram.com/betonesio')

func _on_pedro_social_pressed() -> void:
	OS.shell_open('https://www.instagram.com/pedrosinskicarneiro')

func _on_eduardo_social_pressed() -> void:
	OS.shell_open('https://www.instagram.com/edusilvart')

func _on_back_pressed() -> void:
	leave()
