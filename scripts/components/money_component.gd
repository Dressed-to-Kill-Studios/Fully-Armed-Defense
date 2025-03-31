extends Node
class_name MoneyComponent

signal money_changed(changed_amount: float, new_current_amount: float)
signal money_added(amount_added: float, new_current_amount: float)
signal money_removed(amount_removed: float, new_current_amount: float)

var current_money: float = 0 : set = _set_money


func add_money(amount: float) -> void:
	current_money += amount


func remove_money(amount: float) -> void:
	current_money -= amount


func _set_money(new_value: float) -> void:
	var diffrence: float = new_value - current_money #Positive if money added, negative if money removed
	
	current_money += diffrence
	money_changed.emit(diffrence, current_money)
	
	if signf(diffrence) > 0: #Positive
		money_added.emit(abs(diffrence), current_money)
	elif signf(diffrence) < 0: #Negative
		money_removed.emit(abs(diffrence), current_money)
