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

import UIKit

extension UITextView {
    
    func find(prefixes: Set<String>) -> (prefix: String, word: String, range: NSRange)? {
        guard prefixes.count > 0,
            let result = wordAtCaret,
            !result.word.isEmpty
            else { return nil }
        for prefix in prefixes {
            if result.word.hasPrefix(prefix) {
                return (prefix, result.word, result.range)
            }
        }
        return nil
    }
    
    var wordAtCaret: (word: String, range: NSRange)? {
        guard let caretRange = self.caretRange,
            let result = text.word(at: caretRange)
            else { return nil }
        
        let location = result.range.lowerBound.encodedOffset
        let range = NSRange(location: location, length: result.range.upperBound.encodedOffset - location)
        
        return (result.word, range)
    }
    
    var caretRange: NSRange? {
        guard let selectedRange = self.selectedTextRange else { return nil }
        return NSRange(
            location: offset(from: beginningOfDocument, to: selectedRange.start),
            length: offset(from: selectedRange.start, to: selectedRange.end)
        )
    }
    
}


