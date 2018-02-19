//
//  HasNonObtrusiveLoadingIndicator.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 16/02/2018.
//

import UIKit.UIActivityIndicatorView

public protocol LoadingIndicatorProtocol
{
	/// Starts the loading animation
	func startLoadingAnimation()

	/// Stops the loading animation
	func stopLoadingAnimation()
}

extension UIActivityIndicatorView: LoadingIndicatorProtocol
{
	public func startLoadingAnimation()
	{
		startAnimating()
		isHidden = false
	}

	public func stopLoadingAnimation()
	{
		stopAnimating()
	}
}

public protocol HasNonObtrusiveLoadingIndicator
{
	associatedtype LoadingIndicatorType: LoadingIndicatorProtocol
	var nonObtrusiveLoadingIndicator: LoadingIndicatorType! { get }
}

public extension DefaultViewControllerStateTransitioning where Self: HasNonObtrusiveLoadingIndicator
{
	func showNonObtrusiveLoadingIndicator(for state: StateType, animated: Bool)
	{
		nonObtrusiveLoadingIndicator.startLoadingAnimation()
	}

	func hideNonObtrusiveLoadingIndicator(for state: StateType, animated: Bool)
	{
		nonObtrusiveLoadingIndicator.stopLoadingAnimation()
	}
}
