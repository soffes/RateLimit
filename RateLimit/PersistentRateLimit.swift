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
public class PersistentRateLimit: RateLimit {

	// MARK: - RateLimit

	public override class func resetAllLimits() {
		super.resetAllLimits()

		guard let fileURL = fileURL else { return }
		do {
			try NSFileManager.defaultManager().removeItemAtURL(fileURL)
		} catch {}
	}


	// MARK: - Private

	private static let fileURL: NSURL? = {
		let documents = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last
		return documents?.URLByAppendingPathComponent("SAMPersistentRateLimit.plist")
	}()

	override class func didChangeDictionary() {
		guard let fileURL = fileURL else { return }
		dispatch_async(queue) {
			let dictionary = self.dictionary as NSDictionary
			dictionary.writeToURL(fileURL, atomically: true)
		}
	}
}
