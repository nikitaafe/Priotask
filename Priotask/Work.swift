//
//  Work.swift
//  Priotask
//
//  Created by Nikita Felicia on 26/04/22.
//

import Foundation

struct WorkType {
    let symbolName: String
    let typeName: String
}

struct Work {
    var workName: String
    var workDescription: String
    var seconds: Int
    var workType: WorkType
    
    var timeStamp: Double
}

enum CountdownStats {
    case suspended
    case running
    case paused
}
