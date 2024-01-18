import UIKit

final class PictureTableViewCell: UITableViewCell, DefaultReusableView {
    
    // MARK: Internal properties
    
    var pictureModel: PictureModel? {
        didSet {
            guard let model = pictureModel else {
                return
            }
            coverImage.image = UIImage(named: model.name)
            favoriteButton.tintColor = model.isFavorite ? .yellow : .gray
        }
    }
    
    // MARK: Private properties
    
    private let coverImage: UIImageView = {
        let image = UIImageView()
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16
        
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(.TabPicture.favorite, for: .normal)
        button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private functions
    
    @objc
    private func didTapFavoriteButton() {
    }
    
    private func addSubviews() {
        contentView.addSubview(coverImage)
        contentView.addSubview(favoriteButton)
    }
    
    private func activateConstraints() {
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 200),
            
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            favoriteButton.topAnchor.constraint(equalTo: coverImage.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: -8),
        ])
    }
}
