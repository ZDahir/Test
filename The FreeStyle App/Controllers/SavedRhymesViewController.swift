//
//  savedRhymesViewController.swift
//  The FreeStyle App
//
//  Created by Zaid Dahir on 2021-08-10.
//  Copyright © 2021 Zaid Dahir. All rights reserved.
//

import UIKit

class SavedRhymesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var note_list = [Rhymes]()
    var db:DBHelper = DBHelper()
    
    var filteredList = [Rhymes]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        note_list = db.read()
    }
    
    override func viewDidLoad()
    {
        hideKeyboardWhenTappedAround()
        searchBar.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID", for: indexPath) as! NoteCell
        
        noteCell.titleLabel.text = filteredList[indexPath.row].title
        noteCell.descLabel.text = filteredList[indexPath.row].desc
        
        return noteCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredList.count
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        filteredList = note_list
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let noteDetail = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoteDetailVC") as! NoteDetailVC
        let selectedNote : Rhymes!
        selectedNote = filteredList[indexPath.row]
        noteDetail.selectedNote = selectedNote
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(noteDetail, animated: true)
        
    }
    
    
}

extension SavedRhymesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredList = []
        
        if searchText == ""{
            filteredList = note_list
        }else{
            
            filteredList = note_list.filter({ (title) -> Bool in
                return title.title.lowercased().contains(searchText.lowercased())
            })
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
        
    }
}
