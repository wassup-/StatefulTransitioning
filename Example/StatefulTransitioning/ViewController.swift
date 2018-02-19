//
//  ViewController.swift
//  StatefulTransitioning
//
//  Created by Tom Knapen on 02/16/2018.
//  Copyright (c) 2018 Tom Knapen. All rights reserved.
//

import StatefulTransitioning
import UIKit

protocol CanLoadContent: Stateful
{
	var loadingState: StateType { get }
}

extension CanLoadContent
{
	func startLoading(animated: Bool = true, block: (_ completionHandler: @escaping (StateType) -> Void) -> Void)
	{
		setState(loadingState, animated: animated)
		block { state in
			self.setState(state, animated: animated)
		}
	}
}

enum Fake: Error
{
	case error
}

class ViewController: UIViewController, Stateful, DefaultViewControllerStateTransitioning, HasNonObtrusiveLoadingIndicator
{
	typealias StateType = ViewState
	typealias LoadingIndicatorType = UIActivityIndicatorView

	@IBOutlet weak var nonObtrusiveLoadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var nonObtrusiveErrorLabel: UILabel!

	private let stateMachine: StateMachine<StateType> = StateMachine()
	private lazy var stateTransitioner: ViewControllerStateTransitioner<StateType, ViewController> = ViewControllerStateTransitioner(self)

	var currentState: StateType? {
		return stateMachine.currentState
	}

    override func viewDidLoad()
	{
        super.viewDidLoad()

		setState(.empty(nil), animated: false)
	}

	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)

		refresh()
	}

	func setState(_ newState: StateType, animated: Bool)
	{
		stateMachine.transition(stateTransitioner, to: newState, animated: false, completionHandler: { })
	}

	func showNonObtrusiveError(_ error: Error, for state: ViewState, animated: Bool)
	{
		nonObtrusiveErrorLabel.text = error.localizedDescription
		nonObtrusiveErrorLabel.isHidden = false
	}

	func hideNonObtrusiveError(for state: ViewState, animated: Bool)
	{
		nonObtrusiveErrorLabel.text = nil
		nonObtrusiveErrorLabel.isHidden = true
	}

	func attributedSubtitleForErrorView(state: ViewState) -> NSAttributedString?
	{
		if let description = state.error?.localizedDescription {
			return NSAttributedString(string: description)
		} else {
			return nil
		}
	}
}

var counter: Int = 0
extension ViewController: CanLoadContent
{
	var loadingState: ViewState {
		return .loading(currentState)
	}

	func refresh()
	{
		startLoading { completion in
			DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
				switch counter % 4 {
				case 0:
					completion(.empty(nil))
				case 1:
					completion(.content(Fake.error))
				case 2:
					completion(.content(nil))
				default:
					completion(.empty(Fake.error))
				}

				counter += 1

				DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: self.refresh)
			}
		}
	}
}
