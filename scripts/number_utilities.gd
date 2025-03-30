extends Resource
class_name NumberUtilities

const NUMBER_LOOK_UP: Array = [
	{"value": 1, "suffix": "", "symbol": ""},
	{"value": 1e3, "suffix": "Thousand", "symbol": "K"},
	{"value": 1e6, "suffix": "Million", "symbol": "M"},
	{"value": 1e9, "suffix": "Billion", "symbol": "B"},
	{"value": 1e12, "suffix": "Trillion", "symbol": "T"},
	{"value": 1e15, "suffix": "Quadrillion", "symbol": "Qa"},
	{"value": 1e18, "suffix": "Quintillion", "symbol": "Qi"},
]

static var metric: bool = true


static func temperature(metric_value: float, decimals: bool = false) -> String:
	metric_value = (metric_value * 9 / 5) + 32 if not metric else metric_value
	metric_value = int(floor(metric_value)) if not decimals else metric_value
	return "%sº%s" % [metric_value, "C" if metric else "F"]


static func format(number: float, separator: String = ",") -> String:
	var str_number: String = str(number)
	var parts: PackedStringArray = str_number.split(".")
	var integer_part: String = parts[0]
	var decimal_part: String = "." + parts[1] if parts.size() > 1 else ""
	
	var separated_number: String = ""
	var count: int = 0
	
	for i in integer_part.reverse():
		count += 1
		separated_number = i + separated_number
		if count % 3 == 0 and count != integer_part.length():
			separated_number = separator + separated_number
	
	return separated_number + decimal_part


static func compact_format(value: float, digits: int = 3, abbreviate: bool = true) -> String:
	# Reverse a deep copy to avoid modifying the original lookup
	var lookup: Array = NUMBER_LOOK_UP.duplicate(true)
	lookup.reverse()
	
	var abs_value: float = abs(value)
	var notation: Dictionary = NUMBER_LOOK_UP[0]
	
	# Find the appropriate notation
	var filtered_array: Array = lookup.filter(func(_notation: Dictionary) -> bool: return abs_value >= _notation.value)
	if filtered_array.size() > 0:
		notation = filtered_array[0]
	
	# Adjust digit precision
	digits = digits if abs_value >= 1e3 else 0
	
	var format_string: String = "%.*f%s" if abbreviate else "%.*f %s"
	
	# Return formatted string or "0"
	if value != 0:
		return format_string % [digits, sign(value) * (abs_value / notation.value), notation.symbol if abbreviate else notation.suffix]
	else:
		return "0"
