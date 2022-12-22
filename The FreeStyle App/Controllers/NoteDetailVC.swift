
//  savedRhymesViewController.swift
//  The FreeStyle App
//
//  Created by Zaid Dahir on 2021-08-10.
//  Copyright © 2021 Zaid Dahir. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var descTV: UITextView!
    
    @IBOutlet weak var heart_btn: UIButton!

    
    var selectedNote: Rhymes? = nil
    
    var db:DBHelper = DBHelper()
    
    var isEdited = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTF.delegate = self
        descTV.delegate = self
        
        hideKeyboardWhenTappedAround()


        if (selectedNote != nil){
            titleTF.text = selectedNote?.title
            descTV.text  = selectedNote?.desc
        }
        //titleTF.layer.cornerRadius = 10
      //  titleTF.clipsToBounds = true
        descTV.layer.cornerRadius = 10
        descTV.clipsToBounds = true
        
        if selectedNote?.isFavorite == 1{
            heart_btn.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        }else{
            heart_btn.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        }
    }
    
    @IBAction func fvrtAction(_ sender: Any) {
        if selectedNote?.isFavorite == 1{
            db.updateByID(id: selectedNote?.id ?? 0, isFavorite: 0)
            selectedNote?.isFavorite = 0
            heart_btn.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        }else{
            db.updateByID(id: selectedNote?.id ?? 0, isFavorite: 1)
            selectedNote?.isFavorite = 1
            heart_btn.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)

        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isEdited = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEdited = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if isEdited{
            db.updateVerseDetail(id: selectedNote?.id ?? 0, title: titleTF.text!, desc: descTV.text!)
        }

    }

    @IBAction func saveAction(_ sender: Any) {
        if isEdited{
            db.updateVerseDetail(id: selectedNote?.id ?? 0, title: titleTF.text!, desc: descTV.text!)
        }

        
    }
    
    @IBAction func DeleteNote(_ sender: Any)
    {
        
        db.deleteByID(id: selectedNote?.id ?? 0)
        navigationController?.popViewController(animated: true)

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
//        do {
//            let results:NSArray = try context.fetch(request) as NSArray
//            for result in results
//            {
//                let note = result as! Note
//                if(note == selectedNote)
//                {
//                    note.deletedDate = Date()
//                    try context.save()
//                    navigationController?.popViewController(animated: true)
//                }
//            }
//        }
//        catch
//        {
//            print("Fetch Failed")
//        }
    }
    
    
    @IBAction func ShareNote(_ sender: Any){
        
        let shareController = UIActivityViewController(activityItems: [selectedNote?.desc ?? ""] , applicationActivities: nil)
        
        shareController.popoverPresentationController?.sourceView = super.view
        shareController.popoverPresentationController?.sourceRect = (sender as AnyObject).frame

        self.present(shareController, animated: true, completion: nil)
    
    }
}
