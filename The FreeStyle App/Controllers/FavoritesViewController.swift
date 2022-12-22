//
//  FavoritesViewController.swift
//  The FreeStyle App
//
//  Created by Zaid Dahir on 2021-08-10.
//  Copyright © 2021 Zaid Dahir. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var note_list = [Rhymes]()
    
    //favorites array
    var favorite_list = [Rhymes]()
    var filtered_list = [Rhymes]()
    //
    
    var db:DBHelper = DBHelper()
    
    override func viewWillAppear(_ animated: Bool) {
        note_list = db.read()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        favorite_list = []
        favorite_list = note_list.filter({$0.isFavorite == 1})
        filtered_list = favorite_list
        tableView.reloadData()
    }
    
}

// MARK: - TABLE VIEW
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
       return filtered_list.count
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   {
       
       let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID", for: indexPath) as! NoteCell
       
       
       noteCell.titleLabel.text = filtered_list[indexPath.row].title
       noteCell.descLabel.text = filtered_list[indexPath.row].desc
       
       return noteCell
   }
   
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
       
       let noteDetail = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoteDetailVC") as! NoteDetailVC
       let selectedNote : Rhymes!
       selectedNote = filtered_list[indexPath.row]
       noteDetail.selectedNote = selectedNote
       tableView.deselectRow(at: indexPath, animated: true)
       self.navigationController?.pushViewController(noteDetail, animated: true)
       
   }
   
}


extension FavoritesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered_list = []
        
        if searchText == ""{
            filtered_list = favorite_list
        }else{
            
            filtered_list = favorite_list.filter({ (title) -> Bool in
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
