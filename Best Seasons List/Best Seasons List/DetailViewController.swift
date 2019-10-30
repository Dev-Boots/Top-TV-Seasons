//
//  DetailViewController.swift
//  Best Seasons List
//
//  Created by Andy Almanza on 9/24/18.
//  Copyright © 2018 Andy Almanza. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var artistName: UILabel!
    @IBOutlet weak var kind: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            
            //print("inside configureView, \(detail)")
            if let label = self.artistName {
                label.text = detail.artistName
            }
            if let label = self.kind {
                label.text = detail.kind
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Series? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

