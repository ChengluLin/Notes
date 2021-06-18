//
//  Note.swift
//  Delegate
//
//  Created by ChengLu on 2021/6/11.
//

import Foundation
import UIKit
import CoreData

class Note: NSManagedObject {
    
    override func awakeFromInsert() {
        self.noteID = UUID().uuidString
    }
    
    override func prepareForDeletion() {
        if let imageName = self.imageName {
            let home = URL(fileURLWithPath: NSHomeDirectory())
            let doc = home.appendingPathComponent("Documents")
            let filePath = doc.appendingPathComponent(imageName)
            try? FileManager.default.removeItem(at: filePath)

        }
    }
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.noteID == rhs.noteID
    }
    
    @NSManaged var text: String?
    @NSManaged var noteID: String?
    @NSManaged var imageName: String?

    func image() -> UIImage? {
        if let fileName = self.imageName {
            let home = URL(fileURLWithPath: NSHomeDirectory())
            let doc = home.appendingPathComponent("Documents")
            let filePath = doc.appendingPathComponent(fileName)
            return UIImage(contentsOfFile: filePath.path)
        }
        return nil
    }
}
