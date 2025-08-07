extends Button

func change_language():
	match GameDataGlobal.current_lang:
		"zh":
			GameDataGlobal.set_lang("en")
		"en":
			GameDataGlobal.set_lang("zh")
