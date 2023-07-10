//
//  String+Extension.swift
//  NearMeApp
//
//  Created by Enigma Kod on 10/07/2023.
//

import Foundation

extension String {
    func formattedPhoneForCall() -> String {
        self.replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
