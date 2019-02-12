//
//  Agent.swift
//  Q-learning
//
//  Created by UDLAP24 on 2/8/19.
//  Copyright © 2019 UDLAP24. All rights reserved.
//

import Foundation

// Constantes
var STATES: Int = 0
let GAMMA: Float = 0.80
let EPISODIOS: Int = 10

class Agent {
    // Atributos
    var actualState: Int
    var rootState: Int
    var action: Int
    var nextState: Int
    var possibleActions: [Int]
    var QmaxValueForNextAction: Int
    var actionsDoneByAgent: [Int]
    var goalStateHasBeenReached: Int // 0=No / 1=Yes
    var graph: [[Int]] = []
    var agentsMemory: [[Int]] = []

    // Constructor
    init() {
        rootState = -1
        action = -1
        actualState = -1
        nextState = -1
        possibleActions = []
        QmaxValueForNextAction = 0
        actionsDoneByAgent = []
        goalStateHasBeenReached = 0
        graph = getGraph()
        agentsMemory = initializeMemoryOfAgent()
        STATES = graph.count
    } // Fin constructor

    // Metodos
    func getGraph() -> [[Int]] {
        return [[-1, 0, -1, 0, 0, -1, -1, -1, -1, -1],
                [0, -1, 0, -1, -1, -1, -1, -1, -1, -1],
                [-1, 0, -1, 0, -1, -1, -1, -1, 0, -1],
                [0, -1, 0, -1, 0, -1, -1, 0, 0, -1],
                [0, -1, -1, 0, -1, 0, 0, -1, -1, -1],
                [-1, -1, -1, -1, 0, -1, -1, -1, -1, -1],
                [-1, -1, -1, -1, 0, -1, -1, 0, -1, 100],
                [-1, -1, -1, 0, -1, -1, 0, -1, -1, -1],
                [-1, -1, 0, 0, -1, -1, -1, -1, -1, 100],
                [-1, -1, -1, -1, -1, -1, 0, -1, 0, 100]]
    } // Fin metodo getGraph

    func initializeMemoryOfAgent() -> [[Int]] {
        var memoria: [[Int]] = getGraph()

        for i in 0 ..< (memoria.count) {
            for j in 0 ..< (memoria[0].count) {
                memoria[i][j] = 0
            } // Fin for 2
        } // Fin for 1

        return memoria
    } // Fin initializeMemoryOfAgent

    func TrainOneEpisodeQlearning(root: Int) {
        // Clear actionsDoneByAgent each time a new episode begins
        actionsDoneByAgent = []
        // Set root
        rootState = root
        actualState = rootState
        // Keep track since the root state
        actionsDoneByAgent.append(actualState)
        // Reset flag
        goalStateHasBeenReached = 0

        while goalStateHasBeenReached != 1 {
            // Set as 0 each time a new state will be chossen
            QmaxValueForNextAction = 0
            // Clear array of possibleActions
            possibleActions = []

            // Select 1 actions among all possible actions for the current state
            for j in 0 ..< STATES {
                // Verify if current action is a possible action
                if graph[actualState][j] != -1 {
                    // Only consider posible actions
                    possibleActions.append(j)
                } // Fin if 1
            } // Fin for 1

            // Select the action randomly
            action = possibleActions.randomElement()! // Asegurar que se regresa Int
            // Using this action considering going to the next state
            nextState = action

            // Obtain the Max Q value for next state based in all possible actions
            for k in 0 ..< STATES {
                // Verify that is a possible action
                if graph[nextState][k] != -1 {
                    // Verify if it is the max value for the agents memory
                    if agentsMemory[nextState][k] > QmaxValueForNextAction {
                        // Current value is larger than the previous one
                        QmaxValueForNextAction = agentsMemory[nextState][k]
                    } // Fin if 3
                } // Fin if 2
            } // Fin for 2

            // **The goal state has been reached if the agent is in the final state and following state
            // is also the final state, otherwise if this verification is not done the last row(->) of
            // agentsMemory remains in 0s
            if actualState == (STATES - 1), (nextState == (STATES - 1)) {
                goalStateHasBeenReached = 1
            } // Fin if 4

            // Update agents memory(state,action)
            agentsMemory[actualState][action] = graph[actualState][action] + Int(GAMMA * (Float(QmaxValueForNextAction)))

            // Set the next state as the current state
            actualState = nextState

            // Keep track of the next state
            actionsDoneByAgent.append(actualState)
        } // Fin while
    } // Fin funcion TrainOneEpisodeQlearning

    func printMatrix(matriz: [[Int]]) {
        for i in 0 ..< (matriz.count) {
            print("\(i))", terminator: "")

            for j in 0 ..< (matriz[0].count) {
                print(String(format: "%3d", matriz[i][j]), terminator: "")
            } // Fin for 2
            print("")
        } // Fin for 1
        print("")
    } // Fin funcion printMatrix

    func printMemory() {
        printMatrix(matriz: agentsMemory)
    } // Fin funcion printMemory

    func obtenerMejorCamino(source: Int, destino: Int) -> [Int] {
        var caminoSeguido: [Int]
        var verticeActual: Int
        var mejorSiguienteVertice: Int

        caminoSeguido = []
        verticeActual = source
        caminoSeguido.append(verticeActual)

        // Seguir los mejores vertices para el agente con base al estado actual hasta
        // que el vertice actual sea igual al destino
        while verticeActual != destino {
            // Reiniciar mejorSiguiente vertice
            mejorSiguienteVertice = 0

            // Encontrar el mejor siguiente vertice para el vertice actual
            for i in 1 ..< agentsMemory[0].count {
                // Mejor siguiente vertice si valor es el mas grande para la memoria del agente y todavia no se ha visitado
                if agentsMemory[verticeActual][i] > agentsMemory[verticeActual][mejorSiguienteVertice], !(caminoSeguido.contains(i)) {
                    mejorSiguienteVertice = i
                } // Fin if
            } // Fin for

            // Agregar nuevo mejor elemento
            caminoSeguido.append(mejorSiguienteVertice)
            // Vertice siguiente es el mejor vertice encontrado para el actual
            verticeActual = mejorSiguienteVertice
        } // Fin while

        return caminoSeguido
    } // Fin funcion obtenerMejorCamino
} // Fin clase Agent
