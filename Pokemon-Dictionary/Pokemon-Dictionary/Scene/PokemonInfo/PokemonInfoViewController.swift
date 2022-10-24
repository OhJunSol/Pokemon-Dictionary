//
//  PokemonInfoViewController.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/22.
//

import Foundation
import UIKit
import Combine

//with storyboard
class PokemonInfoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    var viewModel: PokemonInfoViewModel?
    
    private var cancellables: [AnyCancellable] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .overFullScreen
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapButton.isHidden = true
        
        mapButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] searchText in
                guard let self = self,
                      let locations = self.viewModel?.locations else { return }
                let mapVC = PokemonMapViewController(locations: locations)
                mapVC.modalPresentationStyle = .fullScreen
                mapVC.modalTransitionStyle = .crossDissolve
                self.present(mapVC, animated: true)
            }.store(in: &cancellables)
        
        okButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] searchText in
                guard let self = self else { return }
                self.dismiss(animated: false)
            }.store(in: &cancellables)
        
        bind()
    }
    
    func bind() {
        guard let viewModel = viewModel else {
            return
        }
        
        var nameText = viewModel.names.first ?? ""
        for i in 1..<viewModel.names.count {
            nameText += "\n\(viewModel.names[i])"
        }
        self.nameLabel.text = nameText
        
        viewModel.$locations
            .receive(on: RunLoop.main)
            .sink { [weak self] locations in
                guard let self = self else { return }
                self.mapButton.isHidden = locations.count == 0
            }.store(in: &cancellables)
        
        viewModel.$image
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                guard let self = self,
                      let image = image else { return }
                self.imageView.image = image
            }.store(in: &cancellables)
        
        viewModel.$weight
            .receive(on: RunLoop.main)
            .sink { [weak self] weight in
                guard let self = self,
                      let weight = weight else { return }
                self.weightLabel.text = "Weight: \(weight)"
            }.store(in: &cancellables)
        
        viewModel.$height
            .receive(on: RunLoop.main)
            .sink { [weak self] height in
                guard let self = self,
                      let height = height else { return }
                self.heightLabel.text = "Height: \(height)"
            }.store(in: &cancellables)
        
        viewModel.$error
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self,
                      let error = error else { return }
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }.store(in: &cancellables)
        
        viewModel.fetchData()
    }
    
}
