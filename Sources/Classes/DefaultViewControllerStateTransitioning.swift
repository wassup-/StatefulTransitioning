//
//  DefaultViewControllerStateTransitioning.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 17/02/2018.
//

import Foundation
import UIKit

public enum ViewCategory {
	case empty
	case loading
	case error
}

public protocol DefaultViewControllerStateTransitioning: ViewControllerStateTransitioning, ViewStateViewConfiguration {
	/// Returns the view with the specified type for the specified state
	/// - parameter category: The category to return a view for
	/// - parameter state: The state to configure the view with
	/// - returns: A fully configured view, or `nil`
	func view(category: ViewCategory, for state: StateType) -> View?

	/// The transition animation duration
	/// - returns: The transition animation duration
	var stateTransitionAnimationDuration: TimeInterval { get }

	/// The transition animation options
	/// - returns: The transition animation options
	var stateTransitionAnimationOptions: UIViewAnimationOptions { get }

	/// Hides the non-obtrusive loading indicator
	/// - parameter state: The state to hide the loading indicator for
	/// - parameter animated: `true` if animated
	func hideNonObtrusiveLoadingIndicator(for state: StateType, animated: Bool)

	/// Hides the non-obtrusive error
	/// - parameter state: The state to hide the error for
	/// - parameter animated: `true` if animated
	func hideNonObtrusiveError(for state: StateType, animated: Bool)
}

public protocol CollectionViewControllerStateTransitioning: DefaultViewControllerStateTransitioning { }
public protocol TableViewControllerStateTransitioning: DefaultViewControllerStateTransitioning { }

private extension ViewCategory {
	/// Returns a fully configured view
	/// - parameter state: The state to configure the view for
	/// - parameter configurator: The configurator to configure the view with
	/// - returns: A fully configured view
	func view<Configurator>(for state: ViewState, configurator: Configurator) -> View
		where Configurator: ViewStateViewConfiguration,
			  Configurator.StateType == ViewState
	{
		switch self {
		case .empty:
			let view = EmptyView.loadFromNib()
			view.imageView.image = configurator.imageForEmptyView(state: state)
			view.titleLabel.attributedText = configurator.attributedTitleForEmptyView(state: state)
			view.subtitleLabel.attributedText = configurator.attributedSubtitleForEmptyView(state: state)
			return view
		case .loading:
			let view = LoadingView.loadFromNib()
			view.titleLabel.attributedText = configurator.attributedTitleForLoadingView(state: state)
			view.subtitleLabel.attributedText = configurator.attributedSubtitleForLoadingView(state: state)
			return view
		case .error:
			let view = EmptyView.loadFromNib()
			view.imageView.image = configurator.imageForErrorView(state: state)
			view.titleLabel.attributedText = configurator.attributedTitleForErrorView(state: state)
			view.subtitleLabel.attributedText = configurator.attributedSubtitleForErrorView(state: state)
			return view
		}
	}

	/// Removes the associated view from `parent`
	/// - parameter parent: The associated view's parent view
	func removeView(from parent: View) {
		let views: [View]

		switch self {
		case .empty:
			views = parent.subviews.filter { $0 is EmptyView }
		case .loading:
			views = parent.subviews.filter { $0 is LoadingView }
		case .error:
			views = parent.subviews.filter { $0 is ErrorView }
		}

		views.last?.removeFromSuperview()
	}
}

public extension DefaultViewControllerStateTransitioning where StateType == ViewState {
	public func view(category: ViewCategory, for state: StateType) -> View? {
		let view = category.view(for: state, configurator: self)
		view.translatesAutoresizingMaskIntoConstraints = true
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		return view
	}
}

public extension DefaultViewControllerStateTransitioning where Self: BackingViewProvider {
	// MARK: - Properties

	var stateTransitionAnimationDuration: TimeInterval {
		return 0.2
	}

	var stateTransitionAnimationOptions: UIViewAnimationOptions {
		return [.beginFromCurrentState, .transitionCrossDissolve, .curveEaseOut]
	}

	// MARK: - Transitioning

	private func transition(to view: View?, for state: StateType, animated: Bool) {
		guard let view = view else { return }

		// we might be dealing with a `UIScrollView`
		// so fix the origin to (0, 0)
		// this is especially important when adding to a `UITableView` that's using pull-to-refresh
		// because that will change the tablle view's `bounds` property
		view.frame = CGRect(x: 0, y: 0, width: backingView.bounds.width, height: backingView.bounds.height)

		transition(animated: animated) { parent in
			parent.addSubview(view)
		}
	}

	private func transition(from category: ViewCategory, for state: StateType, animated: Bool) {
		transition(animated: animated) { parent in
			switch category {
			case .loading:
				self.hideNonObtrusiveLoadingIndicator(for: state, animated: animated)
			case .error:
				self.hideNonObtrusiveError(for: state, animated: animated)
			default:
				break
			}

			category.removeView(from: parent)
		}
	}

	func transition(animated: Bool, animations: @escaping (View) -> Void) {
		let duration = (animated) ? stateTransitionAnimationDuration : 0.0
		let options = stateTransitionAnimationOptions

		View.transition(
			with: backingView,
			duration: duration,
			options: options,
			animations: { animations(self.backingView) },
			completion: nil)
	}

	// MARK: - Empty

	func showEmptyView(for state: StateType, animated: Bool) {
		transition(
			to: view(category: .empty, for: state),
			for: state,
			animated: animated)
	}

	func hideEmptyView(for state: StateType, animated: Bool) {
		transition(
			from: .empty,
			for: state,
			animated: animated)
	}

	// MARK: - Loading

	func showObtrusiveLoadingIndicator(for state: StateType, animated: Bool) {
		transition(
			to: view(category: .loading, for: state),
			for: state,
			animated: animated)
	}

	func hideLoadingIndicator(for state: StateType, animated: Bool) {
		transition(
			from: .loading,
			for: state,
			animated: animated)
	}

	// MARK: - Error

	func showObtrusiveError(_ error: Error, for state: StateType, animated: Bool) {
		transition(
			to: view(category: .error, for: state),
			for: state,
			animated: animated)
	}

	func hideError(for state: StateType, animated: Bool) {
		transition(
			from: .error,
			for: state,
			animated: animated)
	}
}

public extension DefaultViewControllerStateTransitioning {
	func hideNonObtrusiveLoadingIndicator(for state: StateType, animated: Bool) { }
	func hideNonObtrusiveError(for state: StateType, animated: Bool) { }
}
