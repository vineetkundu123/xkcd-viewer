import Foundation
import TinyConstraints
import UIKit
import SafariServices

final class HomeViewController: UIViewController {
    let viewModel: HomeViewModel
    // MARK: - Setup
    
    required init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(appImage: .info_icon).template, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkText, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkText, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var firstButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkText, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var lastButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkText, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemPurple
        return activityIndicator
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.tintColor = .lightGray
        searchBar.backgroundColor = .white
        searchBar.delegate = self
        return searchBar
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpValues()
        setUpViewModelObservers()
        setUpTapGestureRecogniser()
        viewModel.showLoadingItems()
        viewModel.fetchData()
    }
    
    private func setupView() {
        self.title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(appImage: .empty_star).original,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightBarButtonTapped))
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(infoButton)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        if viewModel.allowBrowsing {
            view.addSubview(searchBar)
            searchBar.topToSuperview(usingSafeArea: true)
            searchBar.leftToSuperview()
            searchBar.rightToSuperview()
            
            titleLabel.topToBottom(of: searchBar, offset: .single)
        } else {
            titleLabel.topToSuperview(offset: .double, usingSafeArea: true)
        }
        
        imageView.widthToSuperview()
        imageView.heightToSuperview()
        imageView.centerXToSuperview()
        imageView.centerYToSuperview()
        scrollView.addSubview(loadingIndicator)
        
        titleLabel.leftToSuperview(offset: .double, relation: .equalOrGreater)
        titleLabel.rightToLeft(of: infoButton, offset: -.single)
        titleLabel.centerXToSuperview()
        infoButton.height(24.0)
        infoButton.width(24.0)
        infoButton.rightToSuperview(offset: -.double, relation: .equalOrLess)
        infoButton.centerY(to: titleLabel)
        titleLabel.bottomToTop(of: scrollView, offset: -.single)
        
        scrollView.centerYToSuperview(offset: 2 * .double)
        scrollView.leftToSuperview(offset: .double)
        scrollView.rightToSuperview(offset: -.double)
        scrollView.height(to: view, multiplier: 0.55)
        
        loadingIndicator.centerXToSuperview()
        loadingIndicator.centerYToSuperview()
        
        if viewModel.allowBrowsing {
            view.addSubview(firstButton)
            view.addSubview(lastButton)
            view.addSubview(previousButton)
            view.addSubview(nextButton)
            
            firstButton.centerY(to: previousButton)
            firstButton.rightToLeft(of: previousButton, offset: -.single)
            firstButton.titleLabel?.edgesToSuperview(insets: TinyEdgeInsets(top: .single, left: .single, bottom: .single, right: .single))
            
            previousButton.topToBottom(of: scrollView, offset: .double)
            previousButton.centerXToSuperview(offset: -4 * .double)
            previousButton.titleLabel?.edgesToSuperview(insets: TinyEdgeInsets(top: .single, left: .single, bottom: .single, right: .single))

            nextButton.centerY(to: previousButton)
            nextButton.centerXToSuperview(offset: 4 * .double)
            nextButton.titleLabel?.edgesToSuperview(insets: TinyEdgeInsets(top: .single, left: .single, bottom: .single, right: .single))

            lastButton.centerY(to: previousButton)
            lastButton.leftToRight(of: nextButton, offset: .single)
            lastButton.titleLabel?.edgesToSuperview(insets: TinyEdgeInsets(top: .single, left: .single, bottom: .single, right: .single))
        }
    }
    
    func setUpValues() {
        previousButton.setTitle(viewModel.previousButtonTitle, for: .normal)
        nextButton.setTitle(viewModel.nextButtonTitle, for: .normal)
        firstButton.setTitle(viewModel.firstButtonTitle, for: .normal)
        lastButton.setTitle(viewModel.lastButtonTitle, for: .normal)
        
        previousButton.tag = HomeViewModel.ActionType.previous.rawValue
        nextButton.tag = HomeViewModel.ActionType.next.rawValue
        firstButton.tag = HomeViewModel.ActionType.first.rawValue
        lastButton.tag = HomeViewModel.ActionType.last.rawValue
        
        searchBar.placeholder = viewModel.searchPlaceholder

        updateButtonStates()
    }
    
    func setUpTapGestureRecogniser() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissPresentedKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func updateButtonStates() {
        firstButton.isEnabled = !viewModel.isFirstStrip
        previousButton.isEnabled = !viewModel.isFirstStrip
        
        lastButton.isEnabled = !viewModel.isLastStrip
        nextButton.isEnabled = !viewModel.isLastStrip
    }
    
    func setUpViewModelObservers() {
        
        viewModel.updateTitle = {[weak self] title in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.titleLabel.text = title
            }
        }
        
        viewModel.updateNavTitle = {[weak self] title in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.title = title
            }
        }
        
        viewModel.updateImage = {[weak self] image, loading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if !loading {
                    self.loadingIndicator.stopAnimating()
                } else {
                    self.loadingIndicator.startAnimating()
                }
                //Reset zoom on scrollview
                self.scrollView.setZoomScale(1.0, animated: false)
                //Set image
                self.imageView.image = image
            }
        }
        
        viewModel.updateBarButtonImage = {[weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.image = image
            }
        }
        
        viewModel.updateButtonState = {[weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateButtonStates()
            }
        }
        
        viewModel.pushController = {[weak self] controller in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        viewModel.presentController = {[weak self] controller in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.present(controller, animated: true, completion: nil)
            }
        }
        
        viewModel.loadSafariController = {[weak self] url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadSafariController(withUrl: url)
            }
        }
    }
}

// MARK: - Delegates
extension HomeViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissPresentedKeyboard()
        viewModel.searchComic(withText: searchBar.text ?? "")
    }
}

// MARK: - Actions

extension HomeViewController {
    @objc private func buttonTapped(_ sender: UIButton) {
        viewModel.handleUserInteraction(withActionType: HomeViewModel.ActionType.init(rawValue: sender.tag))
    }
    
    @objc func rightBarButtonTapped() {
        viewModel.addOrRemoveFavorite()
    }
    
    @objc private func infoButtonTapped(_ sender: UIButton) {
        viewModel.loadExplanation()
    }
    
    @objc private func dismissPresentedKeyboard() {
        searchBar.resignFirstResponder()
    }
}
