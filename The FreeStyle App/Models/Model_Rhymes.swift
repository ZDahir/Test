//
//  Model_Verses.swift
//  The FreeStyle App
//
//  Created by Zaid Dahir on 29/04/2022.
//  Copyright © 2022 Zaid Dahir. All rights reserved.
//

import Foundation

class Rhymes {
    
    var title: String = ""
    var desc: String = ""
    var isFavorite: Int = 0
    var id: Int = 0
    
    init(id: Int,title:String, desc:String, isFavorite:Int)
    {
        self.id = id
        self.title = title
        self.desc = desc
        self.isFavorite = isFavorite
    }
    
}

