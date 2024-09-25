import cosas.*

object camion {
	const property cosas = #{}
		
	method cargar(cosa) {
		cosas.add(cosa)
		//cosas.forEach({cosa => cosa.cambio()}) -> no estaría bien! porque haría que cada vez que se agrega UNA ÚNICA cosa, TODAS se modifiquen nuevamente! El requerimiento pide que ser cargado se modifique la cosa que es cargada, y este es el único método que puede tener esa responsabilidad.
		cosa.cambiar()
	} 

	method descargar(cosa) {
	  cosas.remove(cosa)
	}

	method todoPesoPar() {
	  return cosas.all({cosa => self.esPar(cosa.peso())})
	  //"all" por defecto si no tiene elementos todos cumplen la condición dada! Lo mismo el any.
	}

	method esPar(peso) {
	  return peso.even() //pregunta ya si es par el peso 
	}

	method hayAlgunoQuePesa(peso) {
	  return cosas.any({cosa => cosa.peso() == peso})
	}

	method elDeNivel(nivel) {
		// el find falla por defecto si no existe alguno que cumpla
	  return cosas.find({cosa => cosa.nivelPeligrosidad() == nivel})
	}

	method pesoTotal() {
	  return self.tara() + self.pesoTotalCarga()
	}

	method tara() {
	  return 1000
	}

	method pesoTotalCarga(){
		//el sum por defecto empieza con 0 y luego si todos los objetos o los bloques producen un número los suma al resultado 0 inicial. o sea no fallaría
		return cosas.sum({cosa => cosa.peso()})
		
	//el forEach es solo para ordenes, estaría mal usarlo acá
	/*
		return cosas.map(cosa => cosa.peso()).sum() -> otra forma de hacerlo que no estaría mal
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
	  return self.objetosQueSuperanPeligrosidad(cosa.nivelPeligrosidad()) //ya devuelve set
	}

	method puedeCircularEnRuta(nivelMaximoPeligrosidad) {
	  return not self.excedidoDePeso() and self.ningunoSuperaPeligrosidad(nivelMaximoPeligrosidad)
	  // no está bueno hacer métodos que devuelvan una "negación" siempre es más práctico pensarlos como afirmaciones y luego negarlo de ser necesario.
	}

	method ningunoSuperaPeligrosidad(nivelMaximoPeligrosidad) {
	  return self.objetosQueSuperanPeligrosidad(nivelMaximoPeligrosidad).isEmpty()
	}

	//agregados
	method tieneAlgoQuePesaEntre(min, max) {
	  return cosas.any({cosa => self.pesaEntre(cosa,min,max)})
	}

	method pesaEntre(cosa,min,max) {
	  return cosa.peso().between(min,max)
	}

	method cosaMasPesada() {
	  return cosas.max({cosa => cosa.peso()})
	}

	method pesos() {
	  return cosas.map({cosa => cosa.peso()}).asSet() //el as set es porque todo es set 
	}

	method totalBultos() {
	  return cosas.sum({cosa => cosa.bultos()})
	}

	//transporte
	method transportar(destino, camino){ 
	  self.validarTransportar(destino, camino)
	  destino.almacenar(cosas)
	}

	method validarTransportar(destino, camino){
	  if( self.excedidoDePeso() and not camino.puedeCircular(self) ) {
		//el ver si entra en el almacen lo valida el almacen
		self.error("no se puede valir el transporte")
	   }
	   //conviene delegar la validacion al querer guardar la carga igual
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

  method contiene(cosa) {
	return cosasAlmacenadas.contains(cosa)
  }

  method validarAlmacenar(cosas){
	if(not self.sePuedeAlmacenar(cosas)){
		self.error("no hay suficiente espacio para almacenar")
	}
	//OTROS MENSAJES:
	//"Hay " + self.bultosDisponibles() + " bulto/s disponible/s, pero se requieren " + bultos 
	//"Hay " + self.bultosDisponibles() + " bulto/s disponible/s, pero se requieren " + camion.totalBultos()

  }

  method sePuedeAlmacenar(cosas) {
	return cantidadDeBultosDisponible >= self.bultosOcupaCosas(cosas)
  }

  method bultosOcupaCosas(cosas) {
	return cosas.sum({cosa => cosa.bultos()})
  }
  //Esté código ya lo hace el camión. En este caso igual no está tan mal por si se pasase otro transporte que no tiene el totalBultos(), pero lo mejor hasta este punto sería reutilizar el código.

}

object ruta9 {
	var property nivelPeligrosidadSoportado  = 2500
  method nivelPeligrosidad() { return 11 }
  method puedeCircular(transporte) {
	return transporte.puedeCircularEnRuta(nivelPeligrosidadSoportado)
  }
}

object caminosVecinales {
	var property pesoMaximoSoportable = 2500
  method puedeCircular(transporte) {
	return transporte.pesoTotal() <= pesoMaximoSoportable
  }
}
