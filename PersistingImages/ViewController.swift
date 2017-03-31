//
//  ViewController.swift
//  PersistingImages
//
//  Created by Douglas Galante on 3/29/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var selectedImageTag = 0

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var middleImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestures()
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
    }
    
    
//    func saveImage() {
//        let tag = "placeholderTag"
//        if validation(with: tag) { return }
//        
//        if let image = createPlayerView.playerPictureImageView.image {
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent("\(firstName + lastName + tag).png")
//            
//            do {
//                if let pngImageData = UIImagePNGRepresentation(image) {
//                    print("try write image data")
//                    try pngImageData.write(to: fileURL, options: .atomic)
//                }
//            } catch {
//                print("couldnt write to file")
//            }
//            store.savePlayer(firstName, lastName: lastName, tag: tag, file: "\(firstName + lastName + tag).png")
//        } else {
//            store.savePlayer(firstName, lastName: lastName, tag: tag, file: "\(firstName + lastName + tag).png")
//        }
//        
//        
//        self.blurDelegate?.unBlurView()
//        self.dismiss(animated: true, completion: {
//            if let delegate = self.delegate {
//                delegate.reloadCollectionView(withPlayer: tag)
//            }
//        })
//    }
    
    
    func validation(with tag: String) -> Bool {
        
        //prevents crash if a png already exists
        let fileManager = FileManager.default
        let documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentPath = documentsURL.path
        let filePath = documentsURL.appendingPathComponent("\(tag).png").path
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            for file in files {
                if "\(documentPath)/\(file)" == filePath {
                    print("did not save - found pre-existing png file")
                    return false
                }
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }
        return true
    }
    
    
    
}


