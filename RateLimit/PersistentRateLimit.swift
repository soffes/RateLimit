//
//  PersistentRateLimit.swift
//  RateLimit
//
//  Created by Sam Soffes on 9/10/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import Foundation

/**
Simple utility for only executing code every so often.

All access to this class is thread-safe.

This class has the same functionality as `SAMRateLimit` only times are persisted across application launches. The limits
are separate from non-persisted version.
*/
open class PersistentRateLimit: RateLimit {

	// MARK: - RateLimit

	open override class func resetAllLimits() {
		super.resetAllLimits()

		guard let fileURL = fileURL else { return }
		do {
			try FileManager.default.removeItem(at: fileURL)
		} catch {}
	}


	// MARK: - Private

	fileprivate static let fileURL: URL? = {
		let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
		return documents?.appendingPathComponent("SAMPersistentRateLimit.plist")
	}()

	override class func didChangeDictionary() {
		guard let fileURL = fileURL else { return }
		queue.async {
			let dictionary = self.dictionary as NSDictionary
			dictionary.write(to: fileURL, atomically: true)
		}
	}
}
