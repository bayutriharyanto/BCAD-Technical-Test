//
//  MainMusicViewController.swift
//  BcadSimpleMusicApp
//
//  Created by Bayu Triharyanto on 11/10/24.
//

import UIKit
import SnapKit
import LBTATools
import AVFAudio

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
    
    private let viewModel: MusicViewModel
    
    init(viewModel: MusicViewModel = MusicViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTapGesture()
        setupAudioSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.songListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: viewModel.isPlaying ? 150 : 0, right: 0)
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
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    private func updateNoResultsLabelVisibility() {
        if viewModel.songs.isEmpty && !viewModel.isLoading {
            emptyStateLabel.isHidden = false
            if searchBar.text?.isEmpty ?? true {
                emptyStateLabel.text = "Find your favorite music and enjoy"
            } else {
                emptyStateLabel.text = "No music found"
            }
        } else {
            emptyStateLabel.isHidden = true
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
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
    
    @objc private func previousButtonTapped() {
        viewModel.previousSong()
    }
    
    @objc private func playPauseButtonTapped() {
        viewModel.togglePlayPause()
    }
    
    @objc private func nextButtonTapped() {
        viewModel.nextSong()
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        guard let duration = viewModel.player?.currentItem?.duration else { return }
        let totalSeconds = CMTimeGetSeconds(duration)
        let value = Float64(sender.value) * totalSeconds
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        viewModel.player?.seek(to: seekTime)
    }

}
extension MainMusicViewController: UITableViewDelegate, UITableViewDataSource, MusicViewModelDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchSongs(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? MusicItemTableViewCell else {
            fatalError("Unable to dequeue CustomSongCell")
        }
        let song = viewModel.songs[indexPath.row]
        cell.configure(with: song, isPlaying: viewModel.isCurrentlyPlaying(index: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectSong(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
    }
    
    func viewModelDidUpdateSongs(_ viewModel: MusicViewModel) {
        DispatchQueue.main.async {
            self.songListTableView.reloadData()
            self.updateNoResultsLabelVisibility()
        }
    }
    
    func viewModelDidUpdatePlayingState(_ viewModel: MusicViewModel) {
        DispatchQueue.main.async {
            self.playButton.setImage(viewModel.isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func viewModelDidUpdateLoadingState(_ viewModel: MusicViewModel) {
        DispatchQueue.main.async {
            if viewModel.isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func viewModelDidEncounterError(_ viewModel: MusicViewModel, error: Error) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            self.updateNoResultsLabelVisibility()
        }
    }
    
    func viewModelDidStartPlayingMusic(_ viewModel: MusicViewModel) {
        DispatchQueue.main.async {
            self.showPlayerControls()
            self.trackNameLabel.text = self.viewModel.songs[self.viewModel.currentSongIndex!].title
            self.artistNameLabel.text = self.viewModel.songs[self.viewModel.currentSongIndex!].artist
        }
    }
    
    func viewModelDidUpdateCurrentSong(_ viewModel: MusicViewModel) {
        DispatchQueue.main.async {
            self.songListTableView.reloadData()
            if let currentSongIndex = self.viewModel.currentSongIndex {
                self.trackNameLabel.text = self.viewModel.songs[currentSongIndex].title
                self.artistNameLabel.text = self.viewModel.songs[currentSongIndex].artist
            }
        }
    }
    
    func viewModelDidUpdatePlayerProgress(_ viewModel: MusicViewModel, currentTime: Double, duration: Double) {
        DispatchQueue.main.async {
            self.progressSlider.value = Float(currentTime / duration)
        }
    }
}
