//
//  Extension+ Text.swift
//  DrSmart
//
//  Created by k2 tam on 23/01/2024.
//

import Foundation
import SwiftUI

extension Text {
     func boldKeywords(_ originalText: String, keywords: [String]) -> Text {
        var resultText = Text("")

        var currentIndex = originalText.startIndex

        for keyword in keywords {
            guard let range = originalText.range(of: keyword, range: currentIndex..<originalText.endIndex) else {
                continue
            }

            let beforeKeyword = String(originalText[currentIndex..<range.lowerBound])
            let keywordText = Text(originalText[range.lowerBound..<range.upperBound])
                .bold()

            resultText = resultText + Text(beforeKeyword) + keywordText

            currentIndex = range.upperBound
        }

        let remainingText = String(originalText[currentIndex...])
        resultText = resultText + Text(remainingText)

        return resultText
    }
}




struct DrSmartExtension {
    static func boldKeywordsText(originalText: String, keywords: [String]) -> Text {
        var resultText = Text("")

        var currentIndex = originalText.startIndex

        for keyword in keywords {
            guard let range = originalText.range(of: keyword, range: currentIndex ..< originalText.endIndex) else {
                continue
            }

            resultText = resultText + Text(originalText[currentIndex..<range.lowerBound])
            resultText = resultText + Text(originalText[range.lowerBound..<range.upperBound])
                .bold()

            currentIndex = range.upperBound
        }

        resultText = resultText + Text(originalText[currentIndex...])

        return resultText
    }
}



