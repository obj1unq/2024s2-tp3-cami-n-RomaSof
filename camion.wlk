import cosas.*

object camion {
	const property cosas = #{}
		
	method cargar(unaCosa) {
		cosas.add(unaCosa)
		//cosas.forEach({cosa => cosa.cambio()}) -> estaría bien usar un foreach acá porque NO hay consulta y es solo accion?
		unaCosa.cambio()
	} 

	method descargar(cosa) {
	  cosas.remove(cosa)
	}

	method todoPesoPar() {
	  return  not cosas.isEmpty() and cosas.all({cosa => self.esPar(cosa.peso())})
	}

	method esPar(numero) {
	  return (numero / 2).isInteger()
	}

	method hayAlgunoQuePesa(peso) {
	  return not cosas.isEmpty() and cosas.any({cosa => cosa.peso() == peso})
	}

	method elDeNivel(nivel) {
		//no se si validarlo para que no falle
	  return cosas.find({cosa => cosa.nivelPeligrosidad() == nivel})
	}

	method pesoTotal() {
	  return self.tara() + self.pesoTotalCarga()
	}

	method tara() {
	  return 1000
	}

	method pesoTotalCarga(){
		//aca también fallaría si le pasan una lista vacia, validar?
		return cosas.sum({cosa => cosa.peso()})
		
	/*
		var peso = 0
		cosas.forEach({cosa => peso = peso + cosa.peso()})
		return peso -> estaría mal porque hay una consulta ?
	*/
	/*
		return cosas.map({cosa => cosa.peso()}).sum() -> otra forma de hacerlo que no estaría mal creo
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
	method transportar(destino, camino){ 
	  self.valirdarTransportar(destino, camino)
	  destino.almacenar(cosas)
	}

	method valirdarTransportar(destino, camino){
	  if( not self.puedePasarPor(camino)  and not self.sePuedeAlmacenarEn(destino) ) {
		self.error("no se puede valir el transporte")
	   }
	}

	method puedePasarPor(camino) {
		return camino.dejaCircular(self)
	}

	method sePuedeAlmacenarEn(destino) {
	  return destino.sePuedeAlmacenar(cosas)
	}
}

//almacen y viaje
object almacen {
  const property cosasAlmacenadas = #{}
  var property cantidadDeBultosDisponible = 3 //como en el ejemplo

  method almacenar(cosas) {
	self.validarAlmacenar(cosas) //por si otra cosa que no sea el camion intenta almacenar cosas conviene por ahora tener una validación en el almacen también
	cosasAlmacenadas.addAll(cosas)
	cantidadDeBultosDisponible = cantidadDeBultosDisponible - self.bultosOcupaCosas(cosas)
  }

  method validarAlmacenar(cosas){
	return 
	if(not self.sePuedeAlmacenar(cosas)){
		self.error("no hay suficiente espacio para almacenar" + cosas)
	}
  }

  method sePuedeAlmacenar(cosas) {
	return cantidadDeBultosDisponible >= self.bultosOcupaCosas(cosas)
  }

  method bultosOcupaCosas(cosas) {
	return cosas.sum({cosa => cosa.bultos()})
  }

}

object ruta9 {
  method nivelPeligrosidad() { return 11 }
  method pesoMaximoSoportable() { return 2500 }
  method dejaCircular(transporte) {
	return transporte.puedeCircularEnRuta(self.nivelPeligrosidad())
  }
}

object caminosVecinales {
	var property pesoMaximoSoportable = 2500
  method nivelPeligrosidad() { return 0 } //asumo que es cero porque no dice la consigna y quiero mantener el polimorfismo
  method dejaCircular(transporte) {
	return transporte.pesoTotal() <= pesoMaximoSoportable
  }
}
