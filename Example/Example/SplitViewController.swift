//
//  SplitViewController.swift
//  Example
//
//  Created by Nathan Tannar on 2018-06-15.
//  Copyright © 2018 MessageKit. All rights reserved.
//

import UIKit

final class SplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
}

extension SplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}

