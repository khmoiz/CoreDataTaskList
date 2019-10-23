//
//  Task.swift
//  TaskList
//
//  Created by Moiz Khan on 2019-10-11.
//  Copyright © 2019 MK. All rights reserved.
//  Sheridan ID 9914774771 || UserName : khmoiz
//

import Foundation
class Task {
    var title: String
    var subtitle: String
    var done: Bool
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.done = false
    }
}

