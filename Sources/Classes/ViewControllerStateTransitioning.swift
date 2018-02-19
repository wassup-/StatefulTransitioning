//
//  ViewControllerStateTransitioning.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 16/02/2018.
//

public protocol ViewControllerStateTransitioning: class
{
	/// The associated state type
	associatedtype StateType

	/// Called right before a transition begins
	/// - parameter state: The state we will transition to
	/// - parameter animated: `true` if transition is animated
	func willTransition(to state: StateType, animated: Bool)

	/// Called right after a transition ends
	/// - parameter state: The state we did transition to
	/// - parameter animated: `true` if transition was animated
	func didTransition(to state: StateType, animated: Bool)

	/// Shows the empty view
	/// - parameter state: The state
	/// - parameter animated: `true` if animated
	func showEmptyView(for state: StateType, animated: Bool)

	/// Hides the empty view
	/// - parameter state: The state
	/// - parameter animated: `true` if animated
	func hideEmptyView(for state: StateType, animated: Bool)

	/// Shows an obtrusive error
	/// - parameter state: The state
	/// - parameter animated: `true` if animated
	func showObtrusiveError(_ error: Error, for state: StateType, animated: Bool)

	/// Shows a non-obtrusive error
	/// - parameter state: The state
	/// - parameter animated: `true` if animated
	func showNonObtrusiveError(_ error: Error, for state: StateType, animated: Bool)

	/// Hides the error
	/// - parameter state: The state
	/// - parameter animated: `true` if animated
	func hideError(for state: StateType, animated: Bool)

	/// Shows an obtrusive loading indicator
	/// - parameter state: The state
	/// - parameter animated: `true` if animated
	func showObtrusiveLoadingIndicator(for state: StateType, animated: Bool)

	/// Shows a non-obtrusive loading indicator
	/// - parameter state: The state
	/// - parameter animated: `true` if animated
	func showNonObtrusiveLoadingIndicator(for state: StateType, animated: Bool)

	/// Hides the loading indicator
	/// - parameter state: The state
	/// - parameter animated: `true` if animated
	func hideLoadingIndicator(for state: StateType, animated: Bool)
}

public class ViewControllerStateTransitioner<StateType: ContentState, ControllerType: ViewControllerStateTransitioning>: StateTransitioning
	where ControllerType.StateType == StateType
{
	weak var controller: ControllerType?
	public init(_ controller: ControllerType)
	{
		self.controller = controller
	}

	public func transition(to state: StateType, animated: Bool, completionHandler: @escaping TransitionCompletionBlock)
	{
		if let controller = controller {
			controller.willTransition(to: state, animated: animated)

			controller.hideEmptyView(for: state, animated: animated)
			controller.hideError(for: state, animated: animated)
			controller.hideLoadingIndicator(for: state, animated: animated)

			switch (state.hasContent, state.isLoading, state.error) {
			// CONTENT
			case (true, true, .some(let error)):
				controller.showNonObtrusiveLoadingIndicator(for: state, animated: animated)
				controller.showNonObtrusiveError(error, for: state, animated: animated)
			case (true, true, .none):
				controller.showNonObtrusiveLoadingIndicator(for: state, animated: animated)
			case (true, false, .some(let error)):
				controller.showNonObtrusiveError(error, for: state, animated: animated)
			/// NO CONTENT
			case (false, true, let error):
				if let error = error {
					controller.showNonObtrusiveLoadingIndicator(for: state, animated: animated)
					controller.showObtrusiveError(error, for: state, animated: animated)
				} else {
					controller.showObtrusiveLoadingIndicator(for: state, animated: animated)
				}
			case (false, false, .none):
				controller.showEmptyView(for: state, animated: animated)
			case (false, false, .some(let error)):
				controller.showObtrusiveError(error, for: state, animated: animated)
			default:
				break
			}

			controller.didTransition(to: state, animated: animated)
		}

		completionHandler()
	}
}

public extension ViewControllerStateTransitioning
{
	func willTransition(to state: StateType, animated: Bool) { }
	func didTransition(to state: StateType, animated: Bool) { }

	func showObtrusiveError(_ error: Error, for state: StateType, animated: Bool) { }
	func showNonObtrusiveError(_ error: Error, for state: StateType, animated: Bool) { }
	func hideError(for state: StateType, animated: Bool) { }

	func showObtrusiveLoadingIndicator(for state: StateType, animated: Bool) { }
	func showNonObtrusiveLoadingIndicator(for state: StateType, animated: Bool) { }
	func hideLoadingIndicator(for state: StateType, animated: Bool) { }
}
