extends Node

# Function to randomly get a species card name from the species dictionary
func get_species_name() -> String:
	randomize()
	return species.keys()[randi() % species.size()]

func get_resource_name() -> String:
	randomize()
	var resource_name = null
	var rand_value = randf() * 55
	# Determine the card type based on probabilities
	if rand_value <= 20:
		resource_name = "wood_1"
	elif rand_value <= 20 + 10:
		resource_name = "wood_2"
	elif rand_value <= 20 + 10 + 5:
		resource_name = "wood_3"
	elif rand_value <= 20 + 10 + 5 + 15:
		resource_name = "soil_1"
	else:
		resource_name = "water_1"
	return resource_name

func get_disaster_name() -> String:
	randomize()
	var disaster_name = null
	var rand_value = randf() * 25
	# Determine the card type based on probabilities
	if rand_value <= 8:
		disaster_name = "ant_attack"
	elif rand_value <= 8 + 4:
		disaster_name = "termite_attack"
	elif rand_value <= 8 + 4 + 4:
		disaster_name = "cold_climate"
	elif rand_value <= 8 + 4 + 4 + 2:
		disaster_name = "dry_climate"
	elif rand_value <= 8 + 4 + 4 + 2 + 4:
		disaster_name = "urban_development"
	elif rand_value <= 8 + 4 + 4 + 2 + 4 + 2:
		disaster_name = "blind_snake_invasion"
	else:
		disaster_name = "pangolin_invasion"
	return disaster_name

func get_event_name() -> String:
	randomize()
	var event_name = null
	var rand_value = randf() * 40
	# Determine the card type based on probabilities
	if rand_value <= 10:
		event_name = "dispersal_flight"
	elif rand_value <= 10 + 10:
		event_name = "resource_raid"
	elif rand_value <= 10 + 10 + 10:
		event_name = "effective_communication"
	elif rand_value <= 10 + 10 + 10 + 5:
		event_name = "parasitic_fungus"
	else:
		event_name = "ant_cricket"
	return event_name
	
# data of species cards
var species = {
	"Hodotermopsis": {
		"resource":{
			"wood": 4,
			"soil": 0,
			"water": 0,
			"cold": 1
		},
		"name_cn": "山林原白蟻",
		"description_cn": "技能:  當場上有人翻出「寒冷氣候」，在該牌對那名玩家生效後，山林原白蟻獲得此卡。當獲得「寒冷氣候」時，每隻工蟻當作2隻計算。"
	},
	"Cryptotermes": {
		"resource":{
			"wood": 5,
			"soil": 0,
			"water": 0,
			"cold": 0
		},
		"name_cn": "截頭堆沙白蟻",
		"description_cn": "技能:  可以犧牲掉1隻兵蟻抵擋任何災難卡。"
	},
	"Stylotermes": {
		"resource":{
			"wood": 5,
			"soil": 0,
			"water": 1,
			"cold": 0
		},
		"name_cn": "木鼻白蟻",
		"description_cn": "技能:  不能被掠奪資源。"
	},
	"Prorhinotermes": {
		"resource":{
			"wood": 5,
			"soil": 0,
			"water": 1,
			"cold": 0
		},
		"name_cn": "黃原鼻白蟻",
		"description_cn": "技能:  每當抽到分飛，額外獲得1張白蟻卡。"
	},
	"Coptotermes": {
		"resource":{
			"wood": 5,
			"soil": 0,
			"water": 1,
			"cold": 0
		},
		"name_cn": "台灣家白蟻",
		"description_cn": "技能:  當場上有人翻出「都市開發」，在該牌對那名玩家生效後，台灣家白蟻獲得兩張白蟻卡。"
	},
	"Odontotermes": {
		"resource":{
			"wood": 4,
			"soil": 2,
			"water": 0,
			"cold": 0
		},
		"name_cn": "台灣土白蟻",
		"description_cn": "技能:  可用3點木頭資源跟1點水資源建立實體蟻巢。當具有實體蟻巢時，可以開始種植真菌，下個回合直接獲勝。"
	},
	"Nasutitermes": {
		"resource":{
			"wood": 6,
			"soil": 0,
			"water": 0,
			"cold": 0
		},
		"name_cn": "高砂象白蟻",
		"description_cn": "技能:  可用1點木頭資源跟1點水資源建立實體蟻巢。當具有實體蟻巢時，災害卡對此白蟻無效。"
	},
	"Pericapritermes": {
		"resource":{
			"wood": 2,
			"soil": 4,
			"water": 0,
			"cold": 0
		},
		"name_cn": "新渡戶歪白蟻",
		"description_cn": "技能:  每隻兵蟻能當作2隻計算。"
	}
}

var resource = {
	"wood_1": {
		"name_cn": "少量木材",
		"description_cn": "效果: 獲得1點木材。",
		"effects":{
			"1":{
				"type": "gain_resource",
				"target": "self",
				"select": "wood",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			}
		}
	},
	"wood_2": {
		"name_cn": "中量木材",
		"description_cn": "效果: 獲得2點木材。",
		"effects":{
			"1":{
				"type": "gain_resource",
				"target": "self",
				"select": "wood",
				"value": 2,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			}
		}
	},
	"wood_3": {
		"name_cn": "大量木材",
		"description_cn": "效果: 獲得3點木材。",
		"effects":{
			"1":{
				"type": "gain_resource",
				"target": "self",
				"select": "wood",
				"value": 3,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			}
		}
	},
	"soil_1": {
		"name_cn": "腐植土",
		"description_cn": "效果: 獲得1點土壤。",
		"effects":{
			"1":{
				"type": "gain_resource",
				"target": "self",
				"select": "soil",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			}
		}
	},
	"water_1": {
		"name_cn": "水源",
		"description_cn": "效果: 獲得1點水資源。",
		"effects":{
			"1":{
				"type": "gain_resource",
				"target": "self",
				"select": "water",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			}
		}
	},
}

var disaster = {
	"ant_attack":{
		"name_cn": "螞蟻攻擊",
		"description_cn": "效果: 兵蟻較少的玩家將損失少量白蟻。",
		"effects":{
			"1": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "larvae_number",
				"value": 2,
				"condition": "lower_soldier_number",
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "worker_number",
				"value": 2,
				"condition": "lower_soldier_number",
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"3": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "soldier_number",
				"value": 2,
				"condition": "lower_soldier_number",
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
		}
	},
	"termite_attack":{
		"name_cn": "白蟻入侵",
		"description_cn": "效果: 兵蟻較少的玩家將損失少量資源。",
		"effects":{
			"1": {
				"type": "remove_resource",
				"target": "opponent",
				"select": "wood",
				"value": 2,
				"condition": "lower_soldier_number",
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "remove_resource",
				"target": "opponent",
				"select": "water",
				"value": 2,
				"condition": "lower_soldier_number",
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"3": {
				"type": "remove_resource",
				"target": "opponent",
				"select": "soil",
				"value": 2,
				"condition": "lower_soldier_number",
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
		}
	},
	"cold_climate":{
		"name_cn": "寒冷氣候",
		"description_cn": "效果: 所有玩家損失少量白蟻。此卡對山林原白蟻不造成傷害，並獲得3點寒冷氣候之資源。",
		"effects":{
			"1": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "larvae_number",
				"value": 1,
				"filter": [
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "worker_number",
				"value": 1,
				"filter": [
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"3": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "soldier_number",
				"value": 1,
				"filter": [
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"4": {
				"type": "remove_termite",
				"target": "self",
				"select": "larvae_number",
				"value": 1,
				"filter": [
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"5": {
				"type": "remove_termite",
				"target": "self",
				"select": "worker_number",
				"value": 1,
				"filter": [
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"6": {
				"type": "remove_termite",
				"target": "self",
				"select": "soldier_number",
				"value": 1,
				"filter": [
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"7":{
				"type": "gain_resource",
				"target": "self",
				"select": "cold",
				"value": 2,
				"filter": [
					"Hodotermopsis"
					]
			}
		}
	},
	"dry_climate":{
		"name_cn": "乾燥氣候",
		"description_cn": "效果: 所有玩家損失1張白蟻卡。此卡對截頭堆沙白蟻無效。",
		"effects":{
			"1": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "larvae_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "worker_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"3": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "soldier_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"4": {
				"type": "remove_termite",
				"target": "self",
				"select": "larvae_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"5": {
				"type": "remove_termite",
				"target": "self",
				"select": "worker_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"6": {
				"type": "remove_termite",
				"target": "self",
				"select": "soldier_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
		}
	},
	"urban_development":{
		"name_cn": "都市開發",
		"description_cn": "效果: 所有玩家下回合抽卡-1。此卡對台灣家白蟻無效。。",
		"effects":{
			"1": {
				"type": "draw",
				"target": "opponent",
				"select": "none",
				"value": -1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "draw",
				"target": "self",
				"select": "none",
				"value": -1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
		}
	},
	"blind_snake_invasion":{
		"name_cn": "盲蛇入侵",
		"description_cn": "效果: 所有玩家損失少量白蟻。",
		"effects":{
			"1": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "larvae_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "worker_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"3": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "soldier_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"4": {
				"type": "remove_termite",
				"target": "self",
				"select": "larvae_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"5": {
				"type": "remove_termite",
				"target": "self",
				"select": "worker_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"6": {
				"type": "remove_termite",
				"target": "self",
				"select": "soldier_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
		}
	},
	"pangolin_invasion": {
		"name_cn": "穿山甲入侵",
		"description_cn": "效果: 所有玩家損失中量白蟻。",
		"effects":{
			"1": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "larvae_number",
				"value": 2,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "worker_number",
				"value": 2,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"3": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "soldier_number",
				"value": 2,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"4": {
				"type": "remove_termite",
				"target": "self",
				"select": "larvae_number",
				"value": 2,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"5": {
				"type": "remove_termite",
				"target": "self",
				"select": "worker_number",
				"value": 2,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"6": {
				"type": "remove_termite",
				"target": "self",
				"select": "soldier_number",
				"value": 2,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
		}
	}
}

var event = {
	"dispersal_flight":{
		"name_cn": "分飛",
		"description_cn": "效果: 產生1隻幼蟲。",
		"effects":{
			"1": {
				"type": "spawn",
				"target": "self",
				"select": "none",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			}
		}
	},
	"resource_raid":{
		"name_cn": "資源掠奪",
		"description_cn": "效果: 當對手兵蟻數量不大於你時，掠奪少量資源。",
		"effects":{
			"1": {
				"type": "raid_resource",
				"target": "opponent",
				"select": "wood",
				"value": 2,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "raid_resource",
				"target": "opponent",
				"select": "water",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"3": {
				"type": "raid_resource",
				"target": "opponent",
				"select": "soil",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
		}
	},
	"effective_communication":{
		"name_cn": "有效溝通",
		"description_cn": "效果: 再抽1張牌，且轉變少量工蟻及兵蟻為幼蟲，以重新配置階級。",
		"effects":{
			"1": {
				"type": "draw",
				"target": "self",
				"select": "none",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "reset_caste",
				"target": "self",
				"select": "none",
				"value": 2,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			}
		}
	},
	"parasitic_fungus":{
		"name_cn": "寄生真菌",
		"description_cn": "效果: 移除對手少量白蟻。",
		"effects":{
			"1": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "larvae_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "worker_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"3": {
				"type": "remove_termite",
				"target": "opponent",
				"select": "soldier_number",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			}
		}
	},
	"ant_cricket":{
		"name_cn": "蟻蟋",
		"description_cn": "效果: 移除對手少量資源。",
		"effects":{
			"1": {
				"type": "remove_resource",
				"target": "opponent",
				"select": "wood",
				"value": 2,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"2": {
				"type": "remove_resource",
				"target": "opponent",
				"select": "soil",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
			"3": {
				"type": "remove_resource",
				"target": "opponent",
				"select": "water",
				"value": 1,
				"filter": [
					"Hodotermopsis",
					"Cryptotermes",
					"Stylotermes",
					"Prorhinotermes",
					"Coptotermes",
					"Odontotermes",
					"Nasutitermes",
					"Pericapritermes"
				]
			},
		}
	},
}
