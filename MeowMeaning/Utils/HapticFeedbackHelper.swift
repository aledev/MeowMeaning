//
//  HapticFeedbackHelper.swift
//  MeowMeaning
//
//  Created by Alejandro Ignacio Aliaga Martinez on 11/1/23.
//

import Foundation
import UIKit

class HapticFeedbackHelper {
    // MARK: - Singleton
    static let shared = HapticFeedbackHelper()
    private var haptics: UINotificationFeedbackGenerator? = nil
    
    // MARK: - Initializer
    private init() {
        self.haptics = UINotificationFeedbackGenerator()
    }
    
    // MARK: - Functions
    func notify() {
        self.haptics?.notificationOccurred(.success)
    }
    
}
