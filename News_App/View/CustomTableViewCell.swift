//
//  CustomTableViewCell.swift
//  News_App
//
//  Created by Pushpendra on 26/07/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    let imageViewThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    var callBack:(()->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpObject()
        autoConstraints()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        imageViewThumbnail.addGestureRecognizer(tapGesture)
    }

    func setUpObject() {
        contentView.addSubview(imageViewThumbnail)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(timeLabel)
    }

    @objc func handleImageTap() {
        self.callBack?()
    
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func autoConstraints() {
        NSLayoutConstraint.activate([
            imageViewThumbnail.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageViewThumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageViewThumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageViewThumbnail.heightAnchor.constraint(equalToConstant: 150)
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageViewThumbnail.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}






