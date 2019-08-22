//
//  howViewController.swift
//  Baby in car check IOS
//
//  Created by Areeb Waseem on 6/24/18.
//  Copyright © 2018 Areeb Waseem. All rights reserved.
//

import UIKit

class howViewController: UIViewController {

    @IBOutlet weak var how_it_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        how_it_label.layer.borderColor = UIColor.blue.cgColor
       how_it_label.layer.borderWidth = 2.0
        how_it_label.layer.cornerRadius = 10.0
       how_it_label.layer.shadowColor = UIColor.black.cgColor
      how_it_label.layer.shadowRadius = 0.4
        how_it_label.layer.shadowOpacity=0.1
       how_it_label.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
