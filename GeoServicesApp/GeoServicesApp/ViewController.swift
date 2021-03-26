//
//  ViewController.swift
//  GeoServicesApp
//
//  Created by sambuddha nath on 3/19/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapButtonOne() {
        let vc = PlacesTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
