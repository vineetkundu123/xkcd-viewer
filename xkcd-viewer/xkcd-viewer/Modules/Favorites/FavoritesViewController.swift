import Foundation
import TinyConstraints
import UIKit

final class FavoritesViewController: UIViewController {
    let viewModel: FavoritesViewModel
    // MARK: - Setup
    
    internal lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.alwaysBounceVertical = true
        view.separatorStyle = .singleLine
        view.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .automatic
        }
        
        view.register(FavoriteComicCell.self)
        
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = true
        return view
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateFavorites()
    }
    
    private func setupView() {
        self.title = viewModel.title
        view.backgroundColor = .white

        self.view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: true)
    }
    
    func setUpValues() {}
    
    func setUpViewModelObservers() {
        viewModel.pushController = {[weak self] controller in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        viewModel.refreshFavorites = {[weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Actions

extension FavoritesViewController {
    @objc private func buttonTapped(_ sender: UIButton) {}
}

// MARK: - Delegates

extension FavoritesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteComicCell.self, for: indexPath)
        cell.updateCell(withItem: viewModel.favoriteItems[indexPath.row])
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.loadComicDetails(atIndex: indexPath.row)
    }
}
