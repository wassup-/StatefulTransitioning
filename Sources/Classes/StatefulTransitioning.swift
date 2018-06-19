//
//  File.swift
//  Pods-StatefulTransitioning_Example
//
//  Created by Tom Knapen on 19/02/2018.
//

import Foundation

enum StatefulTransitioning {
	static let bundle = Bundle(for: BundleToken.self)

	static let resourceBundle: Bundle = {
		guard let path = StatefulTransitioning.bundle.path(forResource: "StatefulTransitioning", ofType: "bundle"),
			let bundle = Bundle(path: path) else {
			fatalError("Unable to find resource bundle")
		}
		return bundle
	}()
}

private final class BundleToken {}
