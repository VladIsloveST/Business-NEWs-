//
//  Assembly.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import Foundation
import UIKit

//protocol AssemblyBuilderProtocol {
//    static func createHomeModule() -> UIViewController
//}

class AssemblyBuilder: NSObject {
    
    @IBOutlet weak var viewController: HomeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let view = viewController else { return }
        let networkService = NetworkService()
        let presenter = Presenter(view: view, networkService: networkService)
        view.presenter = presenter
        
    }
}
