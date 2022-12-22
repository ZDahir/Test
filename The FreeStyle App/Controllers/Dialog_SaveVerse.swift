//
//  Dialog_SaveVerse.swift
//  The FreeStyle App
//
//  Created by Zaid Dahir on 2021-08-10.
//  Copyright © 2021 Zaid Dahir. All rights reserved.
//

import UIKit

protocol Save_Delegate{
    func verseSaved(verseTitle:String)
}

class Dialog_SaveVerse: UIViewController {
    
    var delegate: Save_Delegate?
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    @IBOutlet weak var titleField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        containerView.layer.cornerRadius = 10
        
        saveBtn.layer.cornerRadius = 8
        cancelBtn.layer.cornerRadius = 8


        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveBtnTap(){
        
        if titleField.text!.isEmpty{
            alertView(message: "Please enter title to save verse")
        }else{
            self.dismiss(animated: true)
            self.delegate?.verseSaved(verseTitle: titleField.text!)
        }

    }
    
    @IBAction func cancelBtnTap(){
        
        self.dismiss(animated: true)
    }

}
