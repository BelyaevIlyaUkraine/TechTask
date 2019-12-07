//
//  TaskItem.swift
//  TechTask
//
//  Created by Ilya Belyaev on 06/12/2019.
//  Copyright © 2019 BelApps. All rights reserved.
//

import UIKit

class TaskItem: NSObject {
    
    var title = "Hi"
    
    var review = "Hello"
    
    init(_ title_new : String,_ review_new : String) {
        
        title = title_new
        
        review = review_new
    }
}
