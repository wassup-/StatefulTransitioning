//
//  EmptyView.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 15/02/2018.
//

import UIKit

final class EmptyView: View, NibLoadable
{
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
}
