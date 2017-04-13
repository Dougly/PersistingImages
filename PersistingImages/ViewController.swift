//
//  ViewController.swift
//  PersistingImages
//
//  Created by Douglas Galante on 3/29/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var selectedImageTag = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var middleImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestures()
        fetchData()
    }
    
    func addTapGestures() {
        let tapGR0 = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        topImageView.addGestureRecognizer(tapGR0)
        topImageView.tag = 1
        let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        middleImageView.addGestureRecognizer(tapGR1)
        middleImageView.tag = 2
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        bottomImageView.addGestureRecognizer(tapGR2)
        bottomImageView.tag = 3
    }
    
    func save() {
        
    }

}









extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func tappedImage(_ sender: UITapGestureRecognizer) {
        // Make sure device has a camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Save tag of image view we selected
            if let view = sender.view {
                selectedImageTag = view.tag
            }
            
            // Setup and present default Camera View Controller
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
  
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Dismiss the view controller a
        picker.dismiss(animated: true, completion: nil)
        
        // Get the picture we took
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set the picture to be the image of the selected UIImageView
        switch selectedImageTag {
        case 1: topImageView.image = image
        case 2: middleImageView.image = image
        case 3: bottomImageView.image = image
        default: break
        }
        
        // Save imageData to filePath
        
        // Get access to shared instance of the file manager
        let fileManager = FileManager.default
        
        // Get the URL for the users home directory
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Get the document URL as a string
        let documentPath = documentsURL.path
        
        // Create filePath URL by appending final path component (name of image)
        let filePath = documentsURL.appendingPathComponent("\(String(selectedImageTag)).png")
        
        
        // Check for existing image data
        do {
            // Look through array of files in documentDirectory
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            
            for file in files {
                // If we find existing image filePath delete it to make way for new imageData
                if "\(documentPath)/\(file)" == filePath.path {
                    try fileManager.removeItem(atPath: filePath.path)
                }
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }

        
        // Create imageData and write to filePath
        do {
            if let pngImageData = UIImagePNGRepresentation(image) {
                try pngImageData.write(to: filePath, options: .atomic)
            }
        } catch {
            print("couldn't write image")
        }

        // Save filePath and imagePlacement to CoreData
        let container = appDelegate.persistentContainer
        let context = container.viewContext
        let entity = Image(context: context)
        entity.filePath = filePath.path
        
        switch selectedImageTag {
        case 1: entity.placement = "top"
        case 2: entity.placement = "middle"
        case 3: entity.placement = "bottom"
        default:
            break
        }
        appDelegate.saveContext()

    
    }
    
    
    func fetchData() {
        // Set up fetch request
        let container = appDelegate.persistentContainer
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Image>(entityName: "Image")
        
        do {
            // Retrive array of all image entities in core data
            let images = try context.fetch(fetchRequest)
            
            // For each image entity get the imageData from filepath and assign it to image view
            for image in images {
                
                if let placement = image.placement,
                    let filePath = image.filePath {
                    
                    // Retrive image data from filepath and convert it to UIImage
                    if FileManager.default.fileExists(atPath: filePath) {
                        
                        if let contentsOfFilePath = UIImage(contentsOfFile: filePath) {
                            switch placement {
                            case "top": topImageView.image = contentsOfFilePath
                            case "middle": middleImageView.image = contentsOfFilePath
                            case "bottom": bottomImageView.image = contentsOfFilePath
                            default: break
                            }
                        }
                    }
                }
            }
        } catch {
            print("entered catch for image fetch request")
        }
    }
    
   
    
    
    
}




