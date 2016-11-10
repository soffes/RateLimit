//
//  ViewController.swift
//  Example
//
//  Created by Sam Soffes on 6/9/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import UIKit
import RateLimit

class ViewController: UIViewController {

	// MARK: - Properties

	@IBOutlet var timedLabel: UILabel!
	private let timedLimiter = TimedLimiter(limit: 1)

	@IBOutlet var debouncedLabel: UILabel!
	@IBOutlet var debouncedCountLabel: UILabel!
	@IBOutlet var textField: UITextField!
	private var debouncedLimiter: DebouncedLimiter!
	private var debouncedExecutionCount = 0 {
		didSet {
			debouncedCountLabel.text = "\(debouncedExecutionCount)"
		}
	}


	// MARK: - UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		debouncedLimiter = DebouncedLimiter(limit: 0.2) { [weak self] in
			self?.debouncedExecutionCount += 1
			self?.debouncedLabel.text = self?.textField.text
		}
	}


	// MARK: - Actions

	@IBAction func timedExecute(_ sender: UIButton?) {
		timedLimiter.execute {
			timedLabel.text = Date().description
		}
	}

	@IBAction func textDidChange(_ sender: UITextField?) {
		debouncedLimiter.execute()
	}
}
