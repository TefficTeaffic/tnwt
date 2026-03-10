extends Control

#=========объявление объектов
@onready var notepad = $notepad_ui
@onready var buttons = $buttons
@onready var info_topbar = $topbar
@onready var t_label = $topbar/temperature
@onready var zappy_obj = $zappy_ui
@onready var info_attacks = $attack_info
@onready var labely = $attack_info/now_attacking
@onready var button = $attack_info/Button
@onready var sound = $zappy_shoot
@onready var scream_sound = $scream
@onready var fire = $fire_obj
@onready var fail_timer = $fail
@onready var scary_thing = $scary_thing
@onready var cursor = load("res://assets/office/cursory-calm.png")
@onready var cursor_pressed = load('res://assets/office/cursory-wow.png')
var cursor_is_custom = false
var hothothot = false
var office_t = 20
var cooldown = 0
var flash_timer = 0
var func_point = 0


#========функция показа блокнота
func _on_show_notepad_pressed():
	notepad.visible = !notepad.visible
	buttons.visible = !buttons.visible
	info_topbar.hide()
	info_attacks.hide()


func _on_back_button_pressed() -> void:
	notepad.visible = !notepad.visible
	buttons.visible = !buttons.visible
	info_topbar.show()
	info_attacks.show()


#==========функция показа заппи
func _on_show_zappy_pressed():
	GameEvents.hide_fanny_button.emit()
	zappy_obj.show()
	info_topbar.hide()
	info_attacks.hide()
	buttons.hide()
	cursor_is_custom = !cursor_is_custom
#========функция смены курсора на собственный
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(0, 0))


#=============смена курсора при нажатии
func click_check():
	if Input.is_action_pressed("mouse_left_click"):
		Input.set_custom_mouse_cursor(cursor_pressed, Input.CURSOR_ARROW, Vector2(0, 0))
		sound.play()
	else:
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(0, 0))


#======а также при нажатии пробела выход из режима
func _process(_delta):
	if cursor_is_custom and Input.is_action_just_pressed("ui_accept"):
		GameEvents.hide_fanny_button.emit()
		zappy_obj.hide()
		info_topbar.show()
		info_attacks.show()
		buttons.show()
		cursor_is_custom = !cursor_is_custom
		Input.set_custom_mouse_cursor(null)
	else: if cursor_is_custom:
		click_check()
	

#===============функция температуры
func _ready():
	GameEvents.fanny_button_pressed.connect(temperature)
	GameEvents.death.connect(you_died)
	GameEvents.liy_attacking.connect(liy_attacking)
	GameEvents.enough_fight.connect(enough_fight)
	GameEvents.fanny_attacking.connect(fanny_attacking)


func temperature():
	hothothot = !hothothot


func _on_label_flash_timer_timeout() -> void:
	if office_t > 69:
		if flash_timer == 1:
			t_label.label_settings.font_color = Color.DARK_RED
			flash_timer = 0
		else:
			t_label.label_settings.font_color = Color.RED
			flash_timer += 1


func _on_temperature_timer_timeout() -> void:
	if hothothot:
		office_t += 1
		t_label.text = str(office_t) + "°"
	else:
		if cooldown == 3:
			if office_t > 20:
				office_t -= 1
				t_label.text = str(office_t) + "°"
				cooldown = 0
		else: cooldown += 1
	if office_t > 39 and office_t < 60:
		t_label.label_settings.font_color = Color.YELLOW
	else: if office_t > 59 and office_t < 70:
		t_label.label_settings.font_color = Color.ORANGE
	else:
		t_label.label_settings.font_color = Color.BLACK
	
	
	#===================функция огня
	if office_t == 80:
		get_tree().paused = !get_tree().paused
		info_topbar.hide()
		info_attacks.hide()
		buttons.hide()
		fire.show()
		fail_timer.start()
		scream_sound.play()
		func_point = 1


func _on_fail_timeout() -> void:
	if func_point == 1:
		fire.hide()
	else:
		scary_thing.hide()
	get_tree().paused = !get_tree().paused
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
	info_topbar.show()
	info_attacks.show()
	buttons.show()


func you_died():
	get_tree().paused = !get_tree().paused
	info_topbar.hide()
	info_attacks.hide()
	buttons.hide()
	scary_thing.show()
	fail_timer.start()
	scream_sound.play()
	func_point = 2


func _on_button_pressed() -> void:
	GameEvents.fight.emit()
	button.hide()

func fanny_attacking():
	labely.text = "Now attacking:\nFanny"

func liy_attacking():
	labely.text = "Now attacking:\nLiy"

func enough_fight():
	labely.text = "Now attacking:\nnone"
	button.show()
