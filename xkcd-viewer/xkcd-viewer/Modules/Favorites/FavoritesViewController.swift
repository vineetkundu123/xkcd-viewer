import Foundation
import TinyConstraints
import UIKit

final class FavoritesViewController: UIViewController {
    let viewModel: FavoritesViewModel
    // MARK: - Setup
    
    required init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpValues()
        setUpViewModelObservers()
    }
    
    private func setupView() {}
    
    func setUpValues() {}
    
    func setUpViewModelObservers() {}
}

// MARK: - Actions

extension FavoritesViewController {
    @objc private func buttonTapped(_ sender: UIButton) {}
}
