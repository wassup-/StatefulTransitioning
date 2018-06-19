//
//  ViewStateTransitioning.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 15/02/2018.
//

import UIKit

public typealias View = UIView

public protocol ContentState: State {
	/// Wether or not we are loading content
	/// - returns: Wether or not we are loading content
	var isLoading: Bool { get }

	/// Wether or not content is available
	/// - returns: Wether or not content is available
	var hasContent: Bool { get }

	/// The associated error
	/// - returns: The associated error
	var error: Error? { get }
}

public enum ViewState: ContentState {
	/// The loading state
	indirect case loading(ViewState?)

	/// The empty state
	case empty(Error?)

	/// The content state
	case content(Error?)
}

public extension ViewState {
	func compares(equalTo other: ViewState) -> Bool {
		switch (self, other) {
		case let (.loading(lhs), .loading(rhs)):
			if let lhs = lhs, let rhs = rhs {
				return lhs.compares(equalTo: rhs)
			} else {
				return false
			}
		case (.content, .content):
			return true
		case (.empty, .empty):
			return true
		default:
			return false
		}
	}

	var isLoading: Bool {
		switch self {
		case .loading:
			return true
		default:
			return false
		}
	}

	var hasContent: Bool {
		switch self {
		case .content:
			return true
		case .loading(let inner):
			return inner?.hasContent ?? false
		default:
			return false
		}
	}

	var error: Error? {
		switch self {
		case .empty(let error), .content(let error):
			return error
		case .loading(let inner):
			return inner?.error
		}
	}
}
