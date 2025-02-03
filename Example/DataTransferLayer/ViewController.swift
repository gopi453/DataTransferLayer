//
//  ViewController.swift
//  DataTransferLayer
//
//  Created by Gopi Krishna on 01/28/2025.
//  Copyright (c) 2025 Gopi Krishna. All rights reserved.
//

import UIKit
import DataTransferLayer
protocol ViewModelProtocol: AnyObject {
    func requestData<T>(for request: RequestBuilder,_ completion: @escaping (((Result<T, NetworkError>) -> Void)))
}

class BaseViewModel: ViewModelProtocol {
    func requestData<T>(for request: any DataTransferLayer.RequestBuilder, _ completion: @escaping (((Result<T, NetworkError>) -> Void))) {
        self.networkManager.makeRequest(from: request, completion)
    }

    private let networkManager: NetworkManager
    init(networkManager: NetworkManager = .shared()) {
        self.networkManager = networkManager
    }
}

class BaseViewController: UIViewController {

    private(set) var viewModel: ViewModelProtocol

    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        self.title = "Home"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let homeViewModel = viewModel as? HomeViewModel {
            homeViewModel.getHomeData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

struct HomeRequest: RequestBuilder {

    var baseURL: String? {
    "https://jsonplaceholder.typicode.com"
    }

    var path: String {
        "/todos"
    }

}


final class HomeViewModel: BaseViewModel {
    private let request: RequestBuilder = HomeRequest()

    func getHomeData() {
        self.requestData(for: request) { (result: Result<[String: Any], NetworkError>) in
            do {
                let res = try result.get()
                print(res)
            }catch {
                print(error)
            }
        }
    }
}

