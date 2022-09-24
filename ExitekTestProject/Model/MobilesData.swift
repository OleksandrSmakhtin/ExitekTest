//
//  MobilesData.swift
//  ExitekTestProject
//
//  Created by Oleksandr Smakhtin on 23.09.2022.
//

import Foundation
import CoreData
import UIKit

//MARK: - MOBILE STORAGE PROTOCOL
protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

//MARK: - MOBILE DATA
struct MobilesData: MobileStorage {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - GET ALL
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
    
    
    //MARK: - FIND BY IMEI
    func findByImei(_ imei: String) -> Mobile? {
        return Mobile()
    }
    
    //MARK: - SAVE
    func save(_ mobile: Mobile) throws -> Mobile {
        do {
            try context.save()
        } catch {
            print("Save error")
        }
        return mobile
    }
    
    
    //MARK: - DELETE
    func delete(_ product: Mobile) throws {
        context.delete(product)
    }
    
    
    //MARK: - EXISTS
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
        print("-------------------PRODUCT IMEI\(product.imei)")
        var check = 0
        for mobile in mobiles {
            print("--------------------\(mobile.imei)")
            if product.imei == mobile.imei {
                print("--------------CHECK +1")
                check += 1
            }
        }
        if check > 1 {
            print("------------ITEM EXISTS-------------")
            return true
        } else {
            print("------------ITEM DOES'T EXISTS-------")
            return false
        }
    }

}
