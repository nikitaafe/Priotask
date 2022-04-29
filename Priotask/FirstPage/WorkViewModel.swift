//
//  WorkViewModel.swift
//  Priotask
//
//  Created by Nikita Felicia on 26/04/22.
//

import Foundation

class WorkViewModel {
    
    private var work: Work!
    
    private let workTypes: [WorkType] = [
        WorkType(symbolName: "star.fill", typeName: "Priority"),
        WorkType(symbolName: "house.fill", typeName: "Housework"),
        WorkType(symbolName: "gamecontroller.fill", typeName: "Games")
    ]
    
    private var selectedIndex = -1 {
        didSet {
            self.work.workType = self.getWorkTypes()[selectedIndex]
        }
    }
    
    init() {
        work = Work(workName: "", workDescription: "", seconds: 0, workType: .init(symbolName: "", typeName: ""), timeStamp: 0)
    }
    
    func setSelectedIndex(to value: Int) {
        self.selectedIndex = value
    }
    
    func setWorkName(to value: String) {
        self.work.workName = value
    }
    
    func setWorkDescription(to value: String) {
        self.work.workDescription = value
    }
    
    func getSelectedIndex() -> Int {
        self.selectedIndex
    }
    
    func getWork() -> Work {
        return self.work
    }
    
    func getWorkTypes() -> [WorkType]{
        return self.workTypes
    }
    
    func isWorkValid() -> Bool {
        if (!work.workName.isEmpty && !work.workDescription.isEmpty && selectedIndex != -1){
            return true
        }
        return false
    }
    
//
//    func setHours(to value: Int) {
//        self.hours.value = value
//    }
}




