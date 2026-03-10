extends Node2D

@onready var fanny_button = $Canvas/fanny_button
@onready var fanny_obj = $fanny
@onready var liy_obj = $Canvas/liy
@onready var fanny_sprites = [
	load("res://assets/office/фанька.png"),
	load("res://assets/office/fanny_awaking.png"),
	load("res://assets/office/fanny_smile.png"),
	load("res://assets/office/fanny_nooooo.png")
]
@onready var step_timer = $fanny_step
@onready var kill_timer = $long_attack
@onready var liy_sprites = [
	load("res://assets/office/лаййй.png"),
	load("res://assets/office/liy-unpressed.png"),
	load("res://assets/office/liy-pressed.png")
]
var on_screen = true
var is_green = true
var cycle = 0
var is_fanny_active = false
var attack_blocker = false
var can_defeat_fanny = false
var click_count = 0
var is_liy_active = false
var is_pressed = false


func change_color(btn: Button, bg_color: Color, hover_color: Color):
	# Список всех состояний, которые мы хотим обновить
	var states = ["normal", "hover", "pressed"]
	
	for s in states:
		if s == "normal":
			var style = btn.get_theme_stylebox("normal").duplicate()
			style.bg_color = bg_color
			btn.add_theme_stylebox_override(s, style)
		else:
			var style = btn.get_theme_stylebox(s).duplicate()
			style.bg_color = hover_color
			btn.add_theme_stylebox_override(s, style)

func _on_fanny_button_pressed() -> void:
	GameEvents.fanny_button_pressed.emit()
	if is_green:
		change_color(fanny_button, Color.RED, Color.INDIAN_RED)
		is_green = false
	else:
		change_color(fanny_button, Color.GREEN, Color.LIGHT_GREEN)
		is_green = true
	if is_fanny_active and not is_green:
		if can_defeat_fanny:
			attack_blocker = true
		else:
			GameEvents.death.emit()
	else:
		attack_blocker = false


func _ready():
	GameEvents.hide_fanny_button.connect(button_control)
	GameEvents.fight.connect(attack_control)

func attack_control():
	attack(1)


func button_control():
	if on_screen:
		fanny_button.hide()
		on_screen = false
	else:
		fanny_button.show()
		on_screen = true


#=================функция атаки
func attack(point):
	if point == 1:
		if is_green:
			GameEvents.fanny_attacking.emit()
			fanny_obj.texture = fanny_sprites[cycle + 1]
			cycle += 1
			is_fanny_active = true
			fanny_attack()
		else: attack(2)
	else: if point == 2:
		GameEvents.liy_attacking.emit()
		is_liy_active = true
		liy_obj.texture_normal = liy_sprites[1]
		kill_timer.start()

func fanny_attack():
	if cycle != 3:
		step_timer.start()
	else:
		kill_timer.start()
		can_defeat_fanny = true

func _on_fanny_step_timeout() -> void:
	fanny_obj.texture = fanny_sprites[cycle + 1]
	cycle += 1
	fanny_attack()

func _on_long_attack_timeout() -> void:
	GameEvents.death.emit()


func _process(_delta):
	if is_fanny_active and attack_blocker and can_defeat_fanny:
		is_fanny_active = false
		can_defeat_fanny = false
		cycle = 0
		step_timer.stop()
		kill_timer.stop()
		fanny_obj.texture = fanny_sprites[0]
		attack(2)
	if click_count == 6:
		kill_timer.stop()
		@warning_ignore("standalone_expression")
		liy_obj.texture_normal = liy_sprites[0]
		click_count = 0
		is_liy_active = false
		GameEvents.enough_fight.emit()


func _on_liy_pressed() -> void:
	if is_liy_active:
		click_count += 1
		is_pressed = !is_pressed
		if not is_pressed:
			@warning_ignore("standalone_expression")
			liy_obj.texture_normal = liy_sprites[1]
		else:
			@warning_ignore("standalone_expression")
			liy_obj.texture_normal = liy_sprites[2]
