//
//  StateMachineProtocol.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/09/24.
//

import Foundation

public protocol StateMachineProtocol {
    associatedtype State: Equatable
    associatedtype Event
    
    var state: State { get }
    var error: DomainError? { get set }
    
    func handleStateUpdate(_ oldState: State, new newState: State)
    func handleEvent(_ event: Event) -> State?
    func send(event: Event)
    func leaveState(_ state: State)
    func enterState(_ state: State)
}
