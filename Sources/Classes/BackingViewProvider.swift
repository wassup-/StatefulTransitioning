//
//  BackingViewProvider.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 16/02/2018.
//

import UIKit

public protocol BackingViewProvider
{
	/// The backing view
	/// - returns: The backing view
	var backingView: View { get }
}

extension UIViewController: BackingViewProvider
{
	public var backingView: View {
		return view
	}
}

extension View: BackingViewProvider
{
	public var backingView: View {
		return self
	}
}
