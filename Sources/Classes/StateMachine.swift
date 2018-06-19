//
//  StateMachine.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 16/02/2018.
//

import Dispatch

public protocol HasStateMachine {
	/// The associated state type
	associatedtype StateType: State

	/// The state machine
	var stateMachine: StateMachine<StateType> { get }
}

public extension Stateful where Self: HasStateMachine {
	var currentState: StateType? {
		return stateMachine.currentState
	}
}

public final class StateMachine<StateType: State> {
	private let queue = DispatchQueue(label: "be.appwise.statemachine.queue")

	private(set) public var currentState: StateType?

	public init() { }

	private func suspendQueue() {
		queue.suspend()
	}

	private func resumeQueue() {
		queue.resume()
	}

	public func setState(_ newState: StateType?) {
		currentState = newState
	}

	public func transition<TargetType>(_ target: TargetType,
									   to newState: StateType,
									   animated: Bool,
									   completionHandler: @escaping TransitionCompletionBlock)
		where TargetType: StateTransitioning,
		TargetType.StateType == StateType
	{
		queue.async { [weak self] in
			guard let sself = self, sself.currentState?.compares(equalTo: newState) != true else { return }

			sself.suspendQueue()
			sself.setState(newState)

			DispatchQueue.main.async {
				target.transition(to: newState, animated: animated) {
					sself.resumeQueue()
					completionHandler()
				}
			}
		}
	}
}
