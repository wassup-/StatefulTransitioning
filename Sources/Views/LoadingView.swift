//
//  LoadingView.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 15/02/2018.
//

import UIKit

final class LoadingView: View, NibLoadable
{
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
}
