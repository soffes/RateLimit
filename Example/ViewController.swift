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

	@IBOutlet var textLabel: UILabel!

	private let limiter = TimedLimiter(limit: 1)


	// MARK: - Actions

	@IBAction func execute(_ sender: AnyObject?) {
		limiter.execute {
			textLabel.text = Date().description
		}
	}
}
