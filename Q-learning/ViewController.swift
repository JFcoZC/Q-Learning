//
//  ViewController.swift
//  Q-learning
//
//  Created by UDLAP24 on 2/6/19.
//  Copyright © 2019 UDLAP24. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var episodios: Int = 0
    var agente007 = Agent()

    @IBOutlet var labelCounterEpisodios: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelAgenteEstado: UILabel!
    @IBOutlet var textFieldOrigen: UITextField!
    @IBOutlet var textFieldDestino: UITextField!

    @IBAction func clickEntrenar(_: UIButton) {
        // Incrementar contador de episodios de entrenamiento
        episodios = episodios + 1
        labelCounterEpisodios.text = "Nº  Episodios: \(episodios)"

        // Numero aleatorio entre 0 y 9
        let rootRoom = Int(arc4random_uniform(UInt32(agente007.graph.count)))
        // Entrenar al agente
        agente007.TrainOneEpisodeQlearning(root: rootRoom)
        // Animar pasos de entrenamiento
        if(episodios == 1){
          animacionLista(steps: agente007.actionsDoneByAgent)
        } //end if
        //animacionLista(steps: agente007.actionsDoneByAgent)
        // Imprimir memoria en consola
        agente007.printMemory()
    } // Fin funcionEntrenar

    @IBAction func endEditing(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func clickIr(_: UIButton) {
        let origen: Int = Int(textFieldOrigen.text!)!
        let destino: Int = Int(textFieldDestino.text!)!

        let mejorCamino: [Int] = agente007.obtenerMejorCamino(source: origen, destino: destino)
        print(mejorCamino)
        animacionLista(steps: mejorCamino)
    } // Fin click boton ir

    override func viewDidLoad() {
        super.viewDidLoad()
        episodios = 0
    } // Fin funcion viewDidLoad

    func animacionLista(steps: [Int]) {
        
        let delay = 0
        let duration = 0.1
        animate(duration: duration, indice: 0, steps: steps, delay: delay)
    } // Fin funcion animacion

    func animate(duration: Double, indice: Int, steps: [Int], delay: Int) {
        if indice < steps.count {
            let numero = steps[indice]
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(delay), execute: {
                UIView.animate(withDuration: duration, animations: {
                    let nameimage = "pos\(numero)"
                    self.imageView.image = UIImage(named: nameimage)
                    print("\(nameimage)")
                    self.labelAgenteEstado.text = "Agente entrenando..."
                }, completion: {
                    (_: Bool) in
                    self.animate(duration: duration, indice: indice + 1, steps: steps, delay: delay + 100)
                }) // end animate
            }) // end asyncAfter
        } // end if
        else {
            print("El entrenamiento ha terminado")
            labelAgenteEstado.text = "Agente listo!"
        } // end else
    } // end animate
} // Fin clase viewController
