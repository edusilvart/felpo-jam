extends TextureRect


var last_input_type : String
var new_input_type : String

@export var PC : Texture2D
@export var XBOX : Texture2D
@export var PS : Texture2D


func _ready() -> void:
	new_input_type = 'KEYBOARD'
	update_input_icons()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		new_input_type = 'KEYBOARD'
		if new_input_type != last_input_type:
			update_input_icons()
	
	elif event is InputEventJoypadButton and event.pressed:
		get_controller_type(event.device)
	
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) > 0.5:
			get_controller_type(event.device)
	
	

func get_controller_type(device_id) -> void:
	var joy_name = Input.get_joy_name(device_id).to_lower()
	
	if joy_name.contains("xbox"):
		new_input_type = 'XBOX'
	
	elif joy_name.contains("playstation") \
	or joy_name.contains("dualshock") \
	or joy_name.contains("dualsense") \
	or joy_name.contains("ps4") \
	or joy_name.contains("ps5") \
	or joy_name.contains("ps5 controller") \
	or joy_name.contains("wireless controller") \
	or joy_name.contains("sony"):
		new_input_type = 'PLAYSTATION'
	
	else:
		new_input_type = 'XBOX' # controle generico
	
	if new_input_type != last_input_type:
		update_input_icons()

func update_input_icons() -> void:
	last_input_type = new_input_type
	match last_input_type:
		'KEYBOARD':
			texture = PC
		'XBOX':
			texture = XBOX
		'PLAYSTATION':
			texture = PS
