import Foundation
import TinyConstraints

class FavoriteComicCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .left
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var disclosureImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(appImage: .disclosure_indicator)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.backgroundColor = .white
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViewAndLayout() {
        cleanContentView()
        addSubview(titleLabel)
        addSubview(disclosureImageView)
        
        titleLabel.topToSuperview(offset: .double)
        titleLabel.leftToSuperview(offset: .double)
        titleLabel.rightToLeft(of: disclosureImageView, offset: -.double)
        titleLabel.bottomToSuperview(offset: -.double)
        
        disclosureImageView.rightToSuperview(offset: -.double)
        disclosureImageView.centerYToSuperview()
    }

    private func cleanContentView() {
        contentView.subviews.forEach({
            $0.removeFromSuperview()
        })
    }
    
    public func updateCell(withItem item: FavoriteItem) {
        self.titleLabel.text = item.title
        self.disclosureImageView.image = item.disclosureImage
        
        setUpViewAndLayout()
        layoutIfNeeded()
    }
}
