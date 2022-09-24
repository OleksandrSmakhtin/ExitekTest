//
//  MobilesData.swift
//  ExitekTestProject
//
//  Created by Oleksandr Smakhtin on 23.09.2022.
//

import Foundation
import CoreData
import UIKit

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}


struct MobilesData: MobileStorage {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func getAll() -> Set<Mobile> {
        let request = Mobile.fetchRequest()
        var mobilesSet = Set<Mobile>()
        do {
            let mobiles = try! context.fetch(request)
            mobilesSet = Set(mobiles)
        } catch {
            print("GetAll error")
        }
        return mobilesSet
    }
    
    
    
    
    func findByImei(_ imei: String) -> Mobile? {
        return Mobile()
    }
    
    
    
    
    func save(_ mobile: Mobile) throws -> Mobile {
        do {
            try context.save()
        } catch {
            print("Save error")
        }
        return mobile
    }
    
    
    
    
    func delete(_ product: Mobile) throws {
        context.delete(product)
    }
    
    
    
    
    func exists(_ product: Mobile) -> Bool {
        let request = Mobile.fetchRequest()
        var mobiles = [Mobile]()
        do {
            mobiles = try! context.fetch(request)
        } catch {
            print("Exist error")
        }
        print("-----------Total mobiles-----------")
        print(mobiles)
        print("-------------Product---------------")
        print(product)

        if mobiles.contains(product) {
            return true
        } else {
            return false
        }
    }

}


struct Temp {
    let model: String
    let imei: String
}
