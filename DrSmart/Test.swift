//
//  Test.swift
//  DrSmart
//
//  Created by k2 tam on 23/01/2024.
//

import SwiftUI

struct Test: View {
    var body: some View {
        boldKeywordsText(originalText: "The unredacted view modifier makes sure the view will always be visible, even during redaction of the outer container", keywords: ["unredacted view modifier","the view will","during redaction","outer"])
    }
    
    func boldKeywordsText(originalText: String, keywords: [String]) -> Text {
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



#Preview {
    Test()
}
