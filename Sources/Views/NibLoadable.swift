//
//  NibLoadable.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 19/02/2018.
//

import Foundation

protocol NibLoadable
{
	static func loadFromNib() -> Self
}

extension NibLoadable
{
	static func loadFromNib() -> Self
	{
		let nibName = String(describing: self)
		let nib = UINib(nibName: nibName, bundle: StatefulTransitioning.resourceBundle)
		let objects = nib.instantiate(withOwner: nil, options: nil)
		return objects.first as! Self
	}
}
