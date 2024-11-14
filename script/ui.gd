extends CanvasLayer

@onready var fps_count = $fps


func _ready():
	$pause_screen.visible = false


func pause_screen(value : bool) -> void:
	$pause_screen.visible = value


func _process(delta) -> void:
	fps_count.text = str("0" , Engine.get_frames_per_second())
