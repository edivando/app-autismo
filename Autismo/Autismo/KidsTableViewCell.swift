//
//  KidsTableViewCell.swift
//  Autismo
//
//  Created by Edivando Alves on 11/4/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit

class KidsTableViewCell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var name: UILabel!
    
    var edit = {}
    
    
    @IBAction func editProfile(sender: AnyObject) {
        edit()
    }
    
    
}