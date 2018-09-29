/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

internal extension String {
    
    func wordParts(_ range: Range<String.Index>, _ delimiterSet: CharacterSet) -> (left: String.SubSequence, right: String.SubSequence)? {
        let leftView = self[..<range.upperBound]
        let leftIndex = leftView.rangeOfCharacter(from: delimiterSet, options: .backwards)?.upperBound
            ?? leftView.startIndex
        
        let rightView = self[range.upperBound...]
        let rightIndex = rightView.rangeOfCharacter(from: delimiterSet)?.lowerBound
            ?? endIndex
        
        return (leftView[leftIndex...], rightView[..<rightIndex])
    }
    
    func word(at nsrange: NSRange, with delimiterSet: CharacterSet) -> (word: String, range: Range<String.Index>)? {
        guard !isEmpty,
            let range = Range(nsrange, in: self),
            let parts = self.wordParts(range, delimiterSet)
            else { return nil }
        
        // if the left-next character is in the delimiterSet, the "right word part" is the full word
        // short circuit with the right word part + its range
        if let characterBeforeRange = index(range.lowerBound, offsetBy: -1, limitedBy: startIndex),
            let character = self[characterBeforeRange].unicodeScalars.first,
            delimiterSet.contains(character) {
            let right = parts.right
            let word = String(right)
            return (word, right.startIndex ..< right.endIndex)
        }
        
        let joinedWord = String(parts.left + parts.right)
        guard !joinedWord.isEmpty else { return nil }
        return (joinedWord, parts.left.startIndex ..< parts.right.endIndex)
    }
}

extension Character {
    
    static var space: Character {
        return " "
    }
}
