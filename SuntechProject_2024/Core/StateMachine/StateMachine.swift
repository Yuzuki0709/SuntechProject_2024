//
//  StateMachine.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/09/24.
//

import Foundation

final class StateMachine<State, Event>: NSObject, ObservableObject, StateMachineProtocol where State: Equatable {
    
    public init(_ initialState: State) {
        self.state = initialState
    }
    
    func handleStateUpdate(_ oldState: State, new newState: State) {
        fatalError("Override handleStateUpdate(_:, new:) before continuing.")
    }
    
    func handleEvent(_ event: Event) -> State? {
        fatalError("Override handleEvent(_:) before continuing.")
    }
    
    func send(event: Event) {
        if let state = handleEvent(event) {
            self.state = state
        }
    }
    
    func leaveState(_ state: State) {}
    func enterState(_ state: State) {}
    
    @Published public var error: Error?
    @Published private(set) public var state: State {
        willSet { leaveState(state) }
        didSet {
            enterState(state)
            handleStateUpdate(oldValue, new: state)
        }
    }
}
