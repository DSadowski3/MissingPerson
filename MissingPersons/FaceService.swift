//
//  FaceService.swift
//  MissingPersons
//
//  Created by Dominik Sadowski on 6/22/16.
//  Copyright © 2016 Dominik Sadowski. All rights reserved.
//

import Foundation
import ProjectOxfordFace


class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "2df95d95093367def51d42dec4696412")
}
