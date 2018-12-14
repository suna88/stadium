//
//  StartViewController.swift
//  TheAthletic
//
//  Created by Suna on 2018/12/12.
//  Copyright © 2018年 角南佑季. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var content: String?
        textView.font = UIFont(name:"HiraMinProN-W3",size:22)
        
        let ref = Database.database().reference()
        ref.child("articles").child("article1").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            content = value?["content"] as? String ?? ""
            
            self.textView.text = content
            self.textView.sizeToFit()
            self.scrollView.contentSize = CGSize(width:self.view.frame.width, height: self.textView.frame.height + 100)

            // Do any additional setup after loading the view.
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let height = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        textView.heightAnchor.constraint(equalToConstant: height).isActive = true
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
