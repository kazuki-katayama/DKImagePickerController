//
//  DKImagePickerControllerDemoVC.swift
//  DKImagePickerControllerDemo
//
//  Created by ZhangAo on 03/01/2017.
//  Copyright © 2017 ZhangAo. All rights reserved.
//

import UIKit

class DKImagePickerControllerDemoVC: UITableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        
        let destination = segue.destination as! ViewController
        destination.title = cell.textLabel?.text
        
        switch segue.identifier! {
            
        case "Pick All":
            let pickerController = myPicker()
            
            //destination.pickerController = pickerController
            
        case "Pick Photos Only": break
        case "Pick Videos Only": break
        case "Pick All(Only Photos Or Videos)": break
        case "Take A Picture": break
        case "Hides Camera": break
        case "Allows Landscape": break
        case "Single Select": break
        case "Camera Customization": break
        case "UI Customization": break
        case "Layout Customization": break
        default:
            assert(false)
        }
    }
}
