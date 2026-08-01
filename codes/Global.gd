extends Node

var tem_lanterna = true
var task_atual = "Get the flashlight"
var tem_card = false
var tem_id = false
var modo_terror = false
var tem_alicate = false
var tem_martelo = false
var tem_screwdriver = false
var parafuso_solto = false
var mensagem = ""
var documentos = []
var documento_atual = 0
var tem_mapa = false
var tem_paper1 = false
var tem_paper2 = false
var cutscene = false

func _ready():
	print("GLOBAL CARREGADO")
	print(self)
