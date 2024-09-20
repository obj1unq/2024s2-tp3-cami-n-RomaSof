object knightRider {
	method peso() { return 500 }
	method nivelPeligrosidad() { return 10 }
}

object bumblebee {
	var property estaTransformado =  true
	method peso() { return 800 }
  	method nivelPeligrosidad() { 
		const peso = 30
		return
		if (estaTransformado){ peso } else peso / 2
  }
}

object paqueteDeLadrillos {
  var property cantidadLadrillos = 5
  method peso() { return cantidadLadrillos * self.pesoPorLadrillo() }
  method pesoPorLadrillo() { return 2 }
  method nivelPeligrosidad() { return 2 }
}

object arenaAGranel {
	var property peso = 2
	method nivelPeligrosidad() { return 1 }
}

object bateriaAntiaerea {
  var property estaConMisiles = true
  method peso() { 
	const peso = 300
	return
	if (estaConMisiles){ peso } else peso - 100
   }
   method nivelPeligrosidad() { return if (estaConMisiles){ 100 } else 0 }
}

object contenedorPortuario {
  const cosas = #{}
  method agregar(cosa) { cosas.add(cosa) }
  method quitar(cosa) { cosas.remove(cosa) }
  method pesoTotal() { return 100 + self.pesoTotalCarga() }

	method pesoTotalCarga(){
		var peso = 0
		cosas.forEach({cosa => peso = peso + cosa.peso()})
	  return peso

	  /*
	  return cosas.map({cosa => cosa.peso()}).sum()
	  */
	}
	method nivelPeligrosidad() {
	  return if(cosas.isEmpty()){ 0 } else self.cosaMasPeligrosa().nivelPeligrosidad()
	}
	method cosaMasPeligrosa() { return cosas.max({cosa => cosa.nivelPeligrosidad()}) }
}

object residuosRadioactivos {
	var property peso = 100
	method nivelPeligrosidad() { return 200 }
}

object embalajeDeSeguridad {
  var property cubre = residuosRadioactivos
  method peso() { return cubre.peso() }
  method nivelPeligrosidad() { return cubre.nivelPeligrosidad() /2 }
}