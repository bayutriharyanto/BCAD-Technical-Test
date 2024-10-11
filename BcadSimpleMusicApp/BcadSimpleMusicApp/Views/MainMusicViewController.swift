//
//  MainMusicViewController.swift
//  BcadSimpleMusicApp
//
//  Created by Bayu Triharyanto on 11/10/24.
//

import UIKit
import SnapKit
import LBTATools


class MainMusicViewController: UIViewController, UISearchBarDelegate
{
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.delegate = self
        return view
    }()
    
    lazy var songListTableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(MusicItemTableViewCell.self, forCellReuseIdentifier: "SongCell")
        return view
    }()
    lazy var emptyStateLabel: UILabel = {
        let view = UILabel()
        view.text = "Find your favorite music and enjoy"
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = .gray
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        return view
    }()
    lazy var trackNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        return view
    }()
    lazy var artistNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textAlignment = .center
        view.textColor = .black
        return view
    }()
    lazy var musicControllerView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    lazy var playButton: UIButton = {
       let view = UIButton()
        view.setImage(UIImage(systemName: "play.fill"), for: .normal)
        view.withWidth(30)
        view.withHeight(30)
        return view
    }()
    
    
    lazy var nextButton: UIButton = {
       let view = UIButton()
        view.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        view.withWidth(30)
        view.withHeight(30)
        return view
    }()
    lazy var previousButton: UIButton = {
       let view = UIButton()
        view.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        view.withWidth(30)
        view.withHeight(30)
        return view
    }()
    lazy var progressSlider: UISlider = {
        let view = UISlider()
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTapGesture()
    }
    
    private func setupView() {
        searchBar.placeholder = "Search your music here"
        navigationItem.titleView = searchBar
        
        
        self.view.backgroundColor = .white
        self.view.addSubview(songListTableView)
        songListTableView.fillSuperview()
        self.view.addSubview(emptyStateLabel)
        emptyStateLabel.centerInSuperview()
        self.view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        musicControllerView.isHidden = true
        setupMusicController()
    }
    
    private func setupMusicController() {
        let labelStackView = UIStackView(arrangedSubviews: [trackNameLabel, artistNameLabel])
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        
        let controlStackView = UIStackView(arrangedSubviews: [previousButton, playButton, nextButton])
        
        controlStackView.axis = .horizontal
        controlStackView.distribution = .fillEqually
        
        let mainControlStackView = UIStackView(arrangedSubviews: [labelStackView, controlStackView, progressSlider, UIView()])
        mainControlStackView.axis = .vertical
        mainControlStackView.distribution = .fillEqually
        mainControlStackView.spacing = 8
        
        
        self.view.addSubview(musicControllerView)
        musicControllerView.addSubview(mainControlStackView)
        musicControllerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(0)
        }
        mainControlStackView.fillSuperview(padding:
                                            UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
        
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
   
    
    private func showPlayerControls() {
        guard musicControllerView.isHidden else { return }
        
        musicControllerView.transform = CGAffineTransform(translationX: 0, y: 100)
        musicControllerView.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.musicControllerView.transform = .identity
            self.songListTableView.frame = CGRect(x: self.songListTableView.frame.origin.x,
                                          y: self.songListTableView.frame.origin.y,
                                          width: self.songListTableView.frame.width,
                                          height: self.songListTableView.frame.height - 150)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension MainMusicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? MusicItemTableViewCell else {
            fatalError("Unable to dequeue CustomSongCell")
        }
        
        return cell
    }
}
