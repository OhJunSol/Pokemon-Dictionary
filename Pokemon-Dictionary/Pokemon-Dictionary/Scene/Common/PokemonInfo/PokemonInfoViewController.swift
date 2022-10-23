//
//  PokemonInfoView.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/22.
//

import Foundation
import UIKit
import Combine

//from storyboard
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
        
        viewModel.fetchData()
    }
    
    @IBAction func okButtonTouchUpInside(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
}
