//
//  MusicItemTableViewCell.swift
//  BcadSimpleMusicApp
//
//  Created by Bayu Triharyanto on 11/10/24.
//

import UIKit
import LBTATools
import SnapKit

class MusicItemTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    lazy var artistLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .thin)
        return view
    }()
    lazy var albumLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 10, weight: .ultraLight)
        return view
    }()
    
    lazy var albumImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var playingIcon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .gray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let centerChildStackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel, albumLabel])
        centerChildStackView.axis = .vertical
        centerChildStackView.spacing = 4
        centerChildStackView.distribution = .fillProportionally
        
        let mainStackView = UIStackView(arrangedSubviews: [albumImageView, centerChildStackView, playingIcon])
        albumImageView.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        playingIcon.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fillProportionally
        mainStackView.spacing = 8
        
        contentView.addSubview(mainStackView)
        mainStackView.fillSuperview(padding:
                                        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

}
