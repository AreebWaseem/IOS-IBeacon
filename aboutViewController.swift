//
//  aboutViewController.swift
//  Baby in car check IOS
//
//  Created by Areeb Waseem on 6/22/18.
//  Copyright © 2018 Areeb Waseem. All rights reserved.
//

import UIKit

class aboutViewController: UIViewController, UITextViewDelegate{
    
    
    
    
    @IBOutlet weak var about_top_label: UILabel!
    
    var tapTerm:UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    @IBOutlet weak var it_seems_text_view: UITextView!
    
    
    @IBOutlet weak var on_average_text_view: UITextView!
    
    
    @IBOutlet weak var to_a_dentist_text_view: UITextView!
    
    @IBOutlet weak var some_us_senators_text_view: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        draw_about_label()
        it_seems_text_view.delegate = self
        on_average_text_view.delegate = self
        to_a_dentist_text_view.delegate = self
        some_us_senators_text_view.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func draw_about_label() {
    
       about_top_label.layer.borderColor = UIColor.blue.cgColor
        about_top_label.layer.borderWidth = 2.0
        about_top_label.layer.cornerRadius = 10.0
        about_top_label.layer.shadowColor = UIColor.black.cgColor
      about_top_label.layer.shadowRadius = 0.4
        about_top_label.layer.shadowOpacity=0.1
       about_top_label.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        
    }
    
 
    
    
   
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (textView == it_seems_text_view)
        {
        let link = URL(string: "http://www.theage.com.au/victoria/up-to-five-children-are-locked-in-hot-cars-every-day-in-victoria-20151216-glph8g.html")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(link!)
            } else {
               UIApplication.shared.openURL(link!)
            }
        }
        else if (textView == on_average_text_view)
        {
            let link = URL(string: "http://edition.cnn.com/2017/08/01/health/hot-car-deaths/index.html")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(link!)
            } else {
                UIApplication.shared.openURL(link!)
            }
        }
        else if (textView == to_a_dentist_text_view)
        {
            let link = URL(string: "http://www.kidsandcars.org/2016/07/08/fatal-distraction-forgetting-a-child-in-the-backseat-of-a-car-is-a-horrifying-mistake-is-it-a-crime/")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(link!)
            } else {
                UIApplication.shared.openURL(link!)
            }
        }
        else if (textView == some_us_senators_text_view)
        {
            let link = URL(string: "https://www.nbcnews.com/news/us-news/hot-car-deaths-senators-propose-bill-help-prevent-child-heatstroke-n788571")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(link!)
            } else {
                UIApplication.shared.openURL(link!)
            }
        }
        
        return false
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
