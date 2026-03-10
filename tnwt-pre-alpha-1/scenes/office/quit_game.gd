extends Control

#===========объявление переменных и констант
@onready var esc_hold = 0
@onready var labely_pos = Vector2.ZERO
@onready var labely_edit = $labely
const QUIT_DURATION = 1.0
const MAX_SHAKE = 100.0


#============функция выхода из игры
func quit_game(delta):
	if Input.is_action_pressed("ui_cancel"):
		esc_hold += delta
		labely_edit.show()
		
		var progress = esc_hold / QUIT_DURATION
		
		var shake_offset = Vector2(
			randf_range(-1.0, 1.0) * MAX_SHAKE * progress,
			randf_range(-1.0, 1.0) * MAX_SHAKE * progress
		)
		
		labely_edit.position = labely_pos + shake_offset
		
		if esc_hold >= QUIT_DURATION:
			get_tree().quit()
	else:
		esc_hold = 0.0
		labely_edit.hide()
		labely_edit.position = labely_pos 


#===============основной процесс
func _ready():
	labely_pos = labely_edit.position

func _process(delta: float):
	quit_game(delta) 
