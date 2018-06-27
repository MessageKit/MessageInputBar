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

extension NSNotification {
    
    internal var event: KeyboardManager.KeyboardEvent {
        switch self.name {
        case .UIKeyboardWillShow:
            return .willShow
        case .UIKeyboardDidShow:
            return .didShow
        case .UIKeyboardWillHide:
            return .willHide
        case .UIKeyboardDidHide:
            return .didHide
        case .UIKeyboardWillChangeFrame:
            return .willChangeFrame
        case .UIKeyboardDidChangeFrame:
            return .didChangeFrame
        default:
            return .unknown
        }
    }
    
    internal var timeInterval: TimeInterval? {
        guard let value = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return nil }
        return TimeInterval(truncating: value)
    }
    
    internal var animationCurve: UIViewAnimationCurve? {
        guard let index = (userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue, let curve = UIViewAnimationCurve(rawValue:index) else { return nil }
        return curve
    }
    
    internal var animationOptions: UIViewAnimationOptions {
        guard let curve = animationCurve else { return [] }
        switch curve {
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .easeInOut:
            return .curveEaseInOut
        case .linear:
            return .curveLinear
        }
    }
    
    internal var startFrame: CGRect? {
        return (userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    internal var endFrame: CGRect? {
        return (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    internal var isForCurrentApp: Bool? {
        return (userInfo?[UIKeyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue
    }
    
}

