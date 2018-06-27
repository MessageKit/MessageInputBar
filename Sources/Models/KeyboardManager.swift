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

open class KeyboardManager: NSObject, UIGestureRecognizerDelegate {
    
    /// Keyboard events that can happen. Translates directly to `UIKeyboard` notifications from UIKit.
    public enum KeyboardEvent {
        /// Event raised by UIKit's `.UIKeyboardWillShow`.
        case willShow
        
        /// Event raised by UIKit's `.UIKeyboardDidShow`.
        case didShow
        
        /// Event raised by UIKit's `.UIKeyboardWillShow`.
        case willHide
        
        /// Event raised by UIKit's `.UIKeyboardDidHide`.
        case didHide
        
        /// Event raised by UIKit's `.UIKeyboardWillChangeFrame`.
        case willChangeFrame
        
        /// Event raised by UIKit's `.UIKeyboardDidChangeFrame`.
        case didChangeFrame
        
        /// Non-keyboard based event raised by UIKit
        case unknown
    }
    
    /// A callback that passes a `KeyboardNotification` as an input
    public typealias EventCallback = (KeyboardNotification)->Void
    
    /// A weak reference to a view bounded to the top of the keyboard to act as an `InputAccessoryView`
    /// but kept within the bounds of the `UIViewController`s view
    open weak var inputAccessoryView: UIView?
    
    /// A flag that indicates if a portion of the keyboard is visible on the screen
    private(set) public var isKeyboardHidden: Bool = true
    
    /// The `NSLayoutConstraintSet` that holds the `inputAccessoryView` to the bottom if its superview
    private var constraints: NSLayoutConstraintSet?
    
    /// A weak reference to a `UIScrollView` that has been attached for interactive keyboard dismissal
    private weak var scrollView: UIScrollView?
    
    /// The `EventCallback` actions for each `KeyboardEvent`. Default value is EMPTY
    private var callbacks: [KeyboardEvent: EventCallback] = [:]
    
    /// The pan gesture that handles dragging on the `scrollView`
    private var panGesture: UIPanGestureRecognizer?

    /// A cached notification used as a starting point when a user dragging the `scrollView` down
    /// to interactively dismiss the keyboard
    private var cachedNotification: KeyboardNotification?
    
    // MARK: - Initialization
    
    /// Creates a `KeyboardManager` object an binds the view as fake `InputAccessoryView`
    ///
    /// - Parameter inputAccessoryView: The view to bind to the top of the keyboard but within its superview
    public convenience init(inputAccessoryView: UIView) {
        self.init()
        self.bind(inputAccessoryView: inputAccessoryView)
    }
    
    /// Creates a `KeyboardManager` object that observes the state of the keyboard
    public override init() {
        super.init()
        addObservers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - De-Initialization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard Observer
    
    /// Add an observer for each keyboard notification
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidChangeFrame(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidChangeFrame,
                                               object: nil)
    }
    
    // MARK: - Mutate Callback Dictionary
    
    /// Sets the `EventCallback` for a `KeyboardEvent`
    ///
    /// - Parameters:
    ///   - event: KeyboardEvent
    ///   - callback: EventCallback
    /// - Returns: Self
    @discardableResult
    open func on(event: KeyboardEvent, do callback: EventCallback?) -> Self {
        callbacks[event] = callback
        return self
    }
    
    /// Constrains the `inputAccessoryView` to the bottom of its superview and sets the
    /// `.willChangeFrame` and `.willHide` event callbacks such that it mimics an `InputAccessoryView`
    /// that is bound to the top of the keyboard
    ///
    /// - Parameter inputAccessoryView: The view to bind to the top of the keyboard but within its superview
    /// - Returns: Self
    @discardableResult
    open func bind(inputAccessoryView: UIView) -> Self {
        
        self.inputAccessoryView = inputAccessoryView
        assert(inputAccessoryView.superview != nil, "`inputAccessoryView` must have a superview")
        guard let superview = inputAccessoryView.superview else { fatalError() }
        inputAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        constraints = NSLayoutConstraintSet(
            bottom: inputAccessoryView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            left: inputAccessoryView.leftAnchor.constraint(equalTo: superview.leftAnchor),
            right: inputAccessoryView.rightAnchor.constraint(equalTo: superview.rightAnchor)
        ).activate()
        
        callbacks[.willChangeFrame] = { [weak self] (notification) in
            let keyboardHeight = notification.endFrame.height
            guard
                self?.isKeyboardHidden == false || self?.constraints?.bottom?.constant == 0,
                notification.isForCurrentApp else { return }
            self?.animateAlongside(notification) {
                self?.constraints?.bottom?.constant = -keyboardHeight
                self?.inputAccessoryView?.superview?.layoutIfNeeded()
            }
        }
        callbacks[.willHide] = { [weak self] (notification) in
            guard notification.isForCurrentApp else { return }
            self?.animateAlongside(notification) { [weak self] in
                self?.constraints?.bottom?.constant = 0
                self?.inputAccessoryView?.superview?.layoutIfNeeded()
            }
        }
        return self
    }
    
    /// Adds a `UIPanGestureRecognizer` to the `scrollView` to enable interactive dismissal`
    ///
    /// - Parameter scrollView: UIScrollView
    /// - Returns: Self
    @discardableResult
    open func bind(to scrollView: UIScrollView) -> Self {
        self.scrollView = scrollView
        self.scrollView?.keyboardDismissMode = .interactive // allows dismissing keyboard interactively
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer))
        recognizer.delegate = self
        self.panGesture = recognizer
        self.scrollView?.addGestureRecognizer(recognizer)
        return self
    }
    
    // MARK: - Keyboard Notifications
    
    /// An observer method called last in the lifecycle of a keyboard becoming visible
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardDidShow(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didShow]?(keyboardNotification)
    }
    
    /// An observer method called last in the lifecycle of a keyboard becoming hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardDidHide(notification: NSNotification) {
        isKeyboardHidden = true
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didHide]?(keyboardNotification)
    }
    
    /// An observer method called third in the lifecycle of a keyboard becoming visible/hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardDidChangeFrame(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didChangeFrame]?(keyboardNotification)
        cachedNotification = keyboardNotification
    }
    
    /// An observer method called first in the lifecycle of a keyboard becoming visible/hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardWillChangeFrame(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willChangeFrame]?(keyboardNotification)
        cachedNotification = keyboardNotification
    }
    
    /// An observer method called second in the lifecycle of a keyboard becoming visible
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardWillShow(notification: NSNotification) {
        isKeyboardHidden = false
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willShow]?(keyboardNotification)
    }
    
    /// An observer method called second in the lifecycle of a keyboard becoming hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardWillHide(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willHide]?(keyboardNotification)
    }
    
    // MARK: - Helper Methods
    
    private func animateAlongside(_ notification: KeyboardNotification, animations: @escaping ()->Void) {
        UIView.animate(withDuration: notification.timeInterval, delay: 0, options: [notification.animationOptions, .allowAnimatedContent, .beginFromCurrentState], animations: animations, completion: nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    /// Starts with the cached `KeyboardNotification` and calculates a new `endFrame` based
    /// on the `UIPanGestureRecognizer` then calls the `.willChangeFrame` `EventCallback` action
    ///
    /// - Parameter recognizer: UIPanGestureRecognizer
    @objc
    open func handlePanGestureRecognizer(recognizer: UIPanGestureRecognizer) {
        guard
            var keyboardNotification = cachedNotification,
            case .changed = recognizer.state,
            let view = recognizer.view,
            let window = UIApplication.shared.windows.first
            else { return }
        
        let location = recognizer.location(in: view)
        let absoluteLocation = view.convert(location, to: window)
        var frame = keyboardNotification.endFrame
        frame.origin.y = max(absoluteLocation.y, window.bounds.height - frame.height)
        frame.size.height = window.bounds.height - frame.origin.y
        keyboardNotification.endFrame = frame
        callbacks[.willChangeFrame]?(keyboardNotification)
    }
    
    /// Only receive a `UITouch` event when the `scrollView`'s keyboard dismiss mode is interactive
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return scrollView?.keyboardDismissMode == .interactive
    }
    
    /// Only recognice simultaneous gestures when its the `panGesture`
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer === panGesture
    }
    
}
