import cosas.*

object camion {
	const property cosas = #{}
		
	method cargar(unaCosa) {
		cosas.add(unaCosa)
		//cosas.forEach({cosa => cosa.cambio()})
		unaCosa.cambio()
	} 

	method descargar(cosa) {
	  cosas.remove(cosa)
	}

	method todoPesoPar() {
	  return cosas.all({cosa => self.esPar(cosa.peso())})
	}

	method esPar(numero) {
	  return (numero / 2).isInteger()
	}

	method hayAlgunoQuePesa(peso) {
	  return cosas.any({cosa => cosa.peso() == peso})
	}

	method elDeNivel(nivel) {
	  return cosas.find({cosa => cosa.nivelPeligrosidad() == nivel})
	}

	method pesoTotal() {
	  return self.tara() + self.pesoTotalCarga()
	}

	method tara() {
	  return 1000
	}

	method pesoTotalCarga(){
		var peso = 0
		cosas.forEach({cosa => peso = peso + cosa.peso()})
	  return peso

	  /*
	  return cosas.map({cosa => cosa.peso()}).sum()
	  */
	}

	method excedidoDePeso() {
	  return self.pesoTotal() > self.pesoMaximo()
	}

	method pesoMaximo() {
	  return 2500
	}

	method objetosQueSuperanPeligrosidad(nivel) {
	  return cosas.filter({cosa => self.superaNivelPeligrosidad(cosa, nivel)})
	}

	method superaNivelPeligrosidad(cosa, nivel) {
	  return cosa.nivelPeligrosidad() > nivel
	}

	method objetosMasPeligrososQue(cosa) {
	  return self.objetosQueSuperanPeligrosidad(cosa.nivelPeligrosidad()).asSet()
	}

	method puedeCircularEnRuta(nivelMaximoPeligrosidad) {
	  return not self.excedidoDePeso() and self.ningunoSuperaPeligrosidad(nivelMaximoPeligrosidad)
	}

	method ningunoSuperaPeligrosidad(nivelMaximoPeligrosidad) {
	  return self.objetosQueSuperanPeligrosidad(nivelMaximoPeligrosidad).isEmpty()
	}

	//agregados
	method tieneAlgoQuePesaEntre(min, max) {
	  return cosas.any({cosa => self.pesaEntre(cosa,min,max)})
	}

	method pesaEntre(cosa,min,max) {
	  return cosa.peso() >= min and cosa.peso() <= max
	}

	method cosaMasPesada() {
	  return cosas.max({cosa => cosa.peso()})
	}

	method pesos() {
	  return cosas.map({cosa => cosa.peso()}).asSet() //el as set es para probarlo
	}

	method totalBultos() {
	  return cosas.sum({cosa => cosa.bultos()})
	}

	//transporte
	method transportar(destino, camino) {
	  self.valirdarTransportar(destino, camino)
	  destino.almacenar(cosas, self.totalBultos())
	}

	method valirdarTransportar(destino, camino){
	  if( not self.puedeCircularEnRuta(camino.nivelPeligrosidad()) and not self.sePuedeAlmacenarEn(destino) ) {
		self.error("no se puede almacenar la carga en" + destino)
	   }
	}

	method sePuedeAlmacenarEn(destino) {
	  return destino.sePuedeAlmacenar(cosas)
	}
}

//almacen y viaje
object almacen {
  const property cosasAlmacenadas = #{}
  var property cantidadDeBultosDisponible = 3 //como en el ejemplo

  method almacenar(cosas, bultoCosas) {
	self.validarAlmacenar(cosas, bultoCosas)
	cosasAlmacenadas.addAll(cosas)
	cantidadDeBultosDisponible = cantidadDeBultosDisponible - bultoCosas
  }

  method validarAlmacenar(cosas, bultoCosas){
	return 
	if(not self.sePuedeAlmacenar(cosas, bultoCosas)){
		self.error("no hay suficiente espacio para almacenar" + cosas)
	}
  }

  method sePuedeAlmacenar(cosas, bultoCosas) {
	return cantidadDeBultosDisponible >= bultoCosas
  }

}

object ruta9 {
  method nivelPeligrosidad() { return 11 }
  method pesoMaximoSoportable() { return 2500 }
}

object caminosVecinales {
	var property pesoMaximoSoportable = 2500
  method nivelPeligrosidad() { return 0 }
}
