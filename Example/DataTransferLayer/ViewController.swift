//
//  ViewController.swift
//  DataTransferLayer
//
//  Created by Gopi Krishna on 01/28/2025.
//  Copyright (c) 2025 Gopi Krishna. All rights reserved.
//

import UIKit
import DataTransferLayer

class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        self.title = "Home"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getHomeData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

struct HomeRequest: DTLRequestBuilder {

    var baseURL: String? {
    "https://jsonplaceholder.typicode.com"
    }

    var path: String {
        "todos"
    }

}


final class HomeViewModel {
    private let request: DTLRequestBuilder = HomeRequest()
    private let client: DTLClient = .shared()

    func getHomeData() {
        client.makeRequest(from: request, handleResponse)
    }

    private func handleResponse(result: Result<DTLResponse<[String: Any]>, DTLError>) {
        do {
            let res = try result.get()
            print(res.getValue())
        } catch {
            print(error.localizedDescription)
        }
    }
}

