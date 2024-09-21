object knightRider {
	method peso() { return 500 }
	method nivelPeligrosidad() { return 10 }
	method bultos() { return 1 }
	method cambio() {}
}

object bumblebee {
	var property estaTransformado =  true
	method peso() { return 800 }
  	method nivelPeligrosidad() { 
		const peso = 30
		return
		if (estaTransformado){ peso } else peso / 2
  }
  method bultos() { return 2 }
  method cambio() { estaTransformado = true }
}

object paqueteDeLadrillos {
  var property cantidadLadrillos = 5
  method peso() { return cantidadLadrillos * self.pesoPorLadrillo() }
  method pesoPorLadrillo() { return 2 }
  method nivelPeligrosidad() { return 2 }
  method bultos() {
	return 
	if(cantidadLadrillos <= 100){ 1 } else if (cantidadLadrillos > 100 and cantidadLadrillos < 300){ 2 } else{ 3 }
  }
  /*Paquete de ladrillos es 1 hasta 100 ladrillos, 2 de 101 a 300, 3 301 o más*/
  method cambio() { cantidadLadrillos += 12 }
}

object arenaAGranel {
	var property peso = 2
	method nivelPeligrosidad() { return 1 }
	method bultos() { return 1 }
	method cambio() { peso += 20 }
}

object bateriaAntiaerea {
  var property estaConMisiles = true
  method peso() { 
	const peso = 300
	return
	if (estaConMisiles){ peso } else peso - 100
   }
   method nivelPeligrosidad() { return if (estaConMisiles){ 100 } else 0 }

   method bultos() { return if (estaConMisiles){2} else {1} }
   /*Batería antiaérea: 1 si no tiene misiles, 2 si tiene.*/
   method cambio() { estaConMisiles = true }
}

object contenedorPortuario {
  const cosas = #{}
  method agregar(cosa) { cosas.add(cosa) }
  method quitar(cosa) { cosas.remove(cosa) }
  method pesoTotal() { return 100 + self.pesoTotalCarga() }

	method pesoTotalCarga(){
		return cosas.sum({cosa => cosa.peso()})
	/*
	return cosas.map({cosa => cosa.peso()}).sum()
	*/
	}
	method nivelPeligrosidad() {
	  return if(cosas.isEmpty()){ 0 } else self.cosaMasPeligrosa().nivelPeligrosidad()
	}
	method cosaMasPeligrosa() { return cosas.max({cosa => cosa.nivelPeligrosidad()}) }

	method bultos() { return 1 + self.cantidadTotalDeBultos() }
	/*Contenedor portuario: 1 + los bultos que tiene adentro.*/

	method cantidadTotalDeBultos() {
	  return cosas.sum({cosa => cosa.bultos()})
	}

	method cambio() { 
		cosas.forEach({cosa => cosa.cambio()}) //acá estaría bien? es una accion sobre todos los elementos y sin consulta
	 }
}

object residuosRadioactivos {
	var property peso = 100
	method nivelPeligrosidad() { return 200 }
	method bultos() { return 1 }
	method cambio() { peso += 15 }
}

object embalajeDeSeguridad {
  var property cubre = residuosRadioactivos
  method peso() { return cubre.peso() }
  method nivelPeligrosidad() { return cubre.nivelPeligrosidad() /2 }
  method bultos() { return 2 }
  method cambio() {}
}