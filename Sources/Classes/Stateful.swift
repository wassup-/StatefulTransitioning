//
//  Stateful.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 14/02/2018.
//

public typealias TransitionCompletionBlock = () -> Void

public protocol State {
	/// Check if `self` compares equal to `other`
	/// - parameter other: The instance to compare with
	/// - returns: `true` if `self` and `other` compare equal
 	func compares(equalTo other: Self) -> Bool
}

public protocol StateTransitioning {
	/// The associated state type
	associatedtype StateType

	/// Transition to the given state
	/// - parameter state: The state to transition to
	/// - parameter animated: `true` if animated
	/// - parameter completionHandler: The completion handler to call once transitioning is finished
	func transition(to state: StateType, animated: Bool, completionHandler: @escaping TransitionCompletionBlock)
}

public protocol Stateful {
	/// The associated state type
	associatedtype StateType

	/// Sets the current state
	/// - parameter newState: The new state
	/// - parameter animated: `true` if animated
	func setState(_ newState: StateType, animated: Bool)

	/// The current state
	/// - returns: The current state
	var currentState: StateType? { get }
}
