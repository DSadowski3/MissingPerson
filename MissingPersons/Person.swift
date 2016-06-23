//
//  Person.swift
//  MissingPersons
//
//  Created by Dominik Sadowski on 6/22/16.
//  Copyright © 2016 Dominik Sadowski. All rights reserved.
//

import Foundation
import UIKit
import ProjectOxfordFace

class Person {
    var faceID: String?
    var personImage: UIImage?
    var personImageUrl: String?
    
    init(personImageUrl: String){
        self.personImageUrl = personImageUrl
    }
    
    func downloadFaceId() {
        if let img = personImage, let imagData = UIImageJPEGRepresentation(img, 0.8){
            FaceService.instance.client.detectWithData(imagData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                
                if err == nil{
                    var faceId: String?
                    for face in faces{
                        faceId = face.faceId
                        print("Face Id: \(faceId)")
                        break
                    }
                    
                    self.faceID = faceId
                }
            })
        }
    }
}
