//
//  ViewStateViewConfiguration.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 17/02/2018.
//

import Foundation.NSAttributedString
import UIKit.UIImage

public protocol ViewStateViewConfiguration {
	/// The associated state type
	associatedtype StateType

	/// Returns the image to show on the empty view
	/// - parameter state: The state to return an image for
	/// - returns: An image, or `nil`
	func imageForEmptyView(state: StateType) -> UIImage?

	/// Returns the attributed title to show on the empty view
	/// - parameter state: The state to return an attributed title for
	/// - returns: An attributed title, or `nil`
	func attributedTitleForEmptyView(state: StateType) -> NSAttributedString?

	/// Returns the attributed subtitle to show on the empty view
	/// - parameter state: The state to return an attributed subtitle for
	/// - returns: An attributed subtitle, or `nil`
	func attributedSubtitleForEmptyView(state: StateType) -> NSAttributedString?

	/// Returns the attributed title to show on the loading view
	/// - parameter state: The state to return an attributed title for
	/// - returns: An attributed title, or `nil`
	func attributedTitleForLoadingView(state: StateType) -> NSAttributedString?

	/// Returns the attributed subtitle to show on the loading view
	/// - parameter state: The state to return an attributed subtitle for
	/// - returns: An attributed subtitle, or `nil`
	func attributedSubtitleForLoadingView(state: StateType) -> NSAttributedString?

	/// Returns the image to show on the error view
	/// - parameter state: The state to return an image for
	/// - returns: An image, or `nil`
	func imageForErrorView(state: StateType) -> UIImage?

	/// Returns the attributed title to show on the error view
	/// - parameter state: The state to return an attributed title for
	/// - returns: An attributed title, or `nil`
	func attributedTitleForErrorView(state: StateType) -> NSAttributedString?

	/// Returns the attributed title to show on the error view
	/// - parameter state: The state to return an attributed subtitle for
	/// - returns: An attributed subtitle, or `nil`
	func attributedSubtitleForErrorView(state: StateType) -> NSAttributedString?
}

public extension ViewStateViewConfiguration where StateType == ViewState {
	func imageForEmptyView(state: StateType) -> UIImage? {
		return UIImage(
			named: "ic_empty",
			in: StatefulTransitioning.resourceBundle,
			compatibleWith: nil)
	}

	func attributedTitleForEmptyView(state: StateType) -> NSAttributedString? {
		return NSAttributedString(string: "All done!")
	}

	func attributedSubtitleForEmptyView(state: StateType) -> NSAttributedString? {
		return NSAttributedString(string: "Clear screens ahead")
	}

	func attributedTitleForLoadingView(state: StateType) -> NSAttributedString? {
		return NSAttributedString(string: "Loading")
	}

	func attributedSubtitleForLoadingView(state: StateType) -> NSAttributedString? {
		return NSAttributedString(string: "Almost there...")
	}

	func imageForErrorView(state: StateType) -> UIImage? {
		return UIImage(
			named: "ic_error",
			in: StatefulTransitioning.resourceBundle,
			compatibleWith: nil)
	}

	func attributedTitleForErrorView(state: StateType) -> NSAttributedString? {
		return NSAttributedString(string: "Whoops!")
	}

	func attributedSubtitleForErrorView(state: StateType) -> NSAttributedString? {
		return state.error.flatMap { NSAttributedString(string: $0.localizedDescription) }
	}
}
