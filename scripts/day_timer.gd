extends Node
class_name DayTimer

var hour:int = 7
var minute:int = 45
var pm: bool = false

var day_started: bool = false
var day_ended: bool = false

var spedup: bool = false

var accum: float = 0.0

signal day_start
signal day_end
signal time_changed

const REAL_TO_GAME_MINUTES: int = 5
var tick: float = 2.5

func _process(delta: float) -> void:
    accum += delta
    if accum >= tick:
        advance_time()
        accum -= tick
        
    if Input.is_action_pressed("debug_speedup"): 
        tick = 0.5
        spedup = true
    else: 
        spedup = false
        tick = 2.5
    
    

func advance_time():
    minute += REAL_TO_GAME_MINUTES
    if minute >= 60:
        hour += 1
        minute = minute % 60
    if hour >= 12:
        hour = hour % 12
        pm = not pm
    
    emit_signal("time_changed", hour, minute, pm, spedup)
    check_signals()

func check_signals():
    if not day_started and hour == 8 and not pm:
        day_started = true
        emit_signal("day_start")
    elif not day_ended and hour == 8 and pm:
        day_ended = true
        emit_signal("day_end")