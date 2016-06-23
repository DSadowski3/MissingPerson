//
//  ViewController.swift
//  MissingPersons
//
//  Created by Dominik Sadowski on 6/22/16.
//  Copyright © 2016 Dominik Sadowski. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localHOst:6069/img/"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var selectedImg: UIImageView!
    
    var selectedPerson: Person?
    var hasSelectedImage: Bool = false
    
    let imagePicker = UIImagePickerController()
    
    let missingPeople = [
        Person(personImageUrl: "person1.jpg"),
        Person(personImageUrl: "person2.jpg"),
        Person(personImageUrl: "person3.jpg"),
        Person(personImageUrl: "person4.jpg"),
        Person(personImageUrl: "person5.jpg"),
        Person(personImageUrl: "person6.png")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        selectedImg.addGestureRecognizer(tap)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCellCollectionViewCell
        
        let person = missingPeople[indexPath.row]
        let url = "\(baseURL)\(missingPeople[indexPath.row])"
        cell.configureCell(person)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedPerson = missingPeople[indexPath.row]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCellCollectionViewCell
        cell.configureCell(selectedPerson!)
        cell.setSelected()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg.image = pickedImage
            hasSelectedImage = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadPicker(gesture: UIGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Select Oerson", message: "Please select a missing person to check", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkMatch(sender: AnyObject) {
        if selectedPerson == nil || !hasSelectedImage{
            showErrorAlert()
        } else {
            if let myImg = selectedImg.image, let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
                FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                    
                    if err == nil {
                        var faceId: String?
                        for face in faces {
                            faceId = face.faceId
                            break
                        }
                        if faceId != nil {
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceID, faceId2: faceId, completionBlock: { (result: MPOVerifyResult!,err: NSError!) in
                                
                                if err == nil {
                                    print(result.confidence)
                                    print(result.isIdentical)
                                    print(result.debugDescription)
                                } else {
                                    print(err.debugDescription)
                                }
                            })
                        }
                    }
                })
            }
        }
        
    }

}

