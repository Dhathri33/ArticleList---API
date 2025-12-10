//
//  Extensions.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/15/25.
//

import UIKit
import CoreData

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    func showRetryAlert(title: String, message: String, retryHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {
            _ in retryHandler()
        }))
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
}

extension CountryCore {
    func toModel() -> Country {
        return Country(
            capital: self.capital ?? "",
            code: self.code ?? "",
            name: self.name ?? "",
            region: self.region ?? ""
        )
    }
    
    static func fromModel(_ model: Country, context: NSManagedObjectContext) {
        let item = CountryCore(context: context)
        item.name = model.name
        item.capital = model.capital
        item.region = model.region
        item.code = model.code
    }
}
