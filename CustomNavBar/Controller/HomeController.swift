//
//  ViewController.swift
//  CustomNavBar
//
//  Created by 刘敏 on 2018/10/26.
//  Copyright © 2018 刘敏. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    var videos: [Video] = {
//        var kanyeChannel = Channel()
//        kanyeChannel.name = "KanyeIsTheBestChannel"
//        kanyeChannel.profileImageName = "kanye_profile"
//
//        var blankSpaceVideo = Video()
//        blankSpaceVideo.title = "Taylor Swift - Blank Space"
//        blankSpaceVideo.thumbnailImageName = "Taylor-Swift1"
//        blankSpaceVideo.channel = kanyeChannel
//        blankSpaceVideo.numberOfViews = 23983420
//
//
//        var badBloodVideo = Video()
//        badBloodVideo.title = "Taylor Swift - Bad Blood Featuring Kendrick Lamer"
//        badBloodVideo.thumbnailImageName = "Taylor-Swift2"
//        badBloodVideo.channel = kanyeChannel
//        badBloodVideo.numberOfViews = 34091234
//
//        return [blankSpaceVideo, badBloodVideo]
//    }()
    
    var videos: [Video]?
    
    func fetchVideos() {
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                self.videos = [Video]()
                
                for dictionary in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    let channelDict = dictionary["channel"] as! [String: AnyObject]
                    let channel = Channel()
                    channel.name = channelDict["name"] as? String
                    channel.profileImageName = channelDict["profile_image_name"] as? String
                    
                    video.channel = channel
                    
                    self.videos?.append(video)
                }
                
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
            
            } catch let jsonError {
                print(jsonError)
            }
            
        }.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        collectionView.backgroundColor = UIColor.white
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        
        // let the content totally beneath the menu bar
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        setupNavBarButtons()
        setupMenuBar()
    }
    
    private func setupNavBarButtons() {
        // search button
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBtn = UIButton()
        searchBtn.setImage(searchImage, for: .normal)
        searchBtn.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        
        
        let searchBarButton = UIBarButtonItem(customView: searchBtn)
        searchBarButton.customView?.widthAnchor.constraint(equalToConstant: 22).isActive = true
        searchBarButton.customView?.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        // more button
        let moreImage = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
        let moreBtn = UIButton()
        moreBtn.setImage(moreImage, for: .normal)
        moreBtn.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
    
        
        let moreBarButton = UIBarButtonItem(customView: moreBtn)
        moreBarButton.customView?.widthAnchor.constraint(equalToConstant: 22).isActive = true
        moreBarButton.customView?.heightAnchor.constraint(equalToConstant: 22).isActive = true
      
        
        
        
        navigationItem.rightBarButtonItems = [moreBarButton, searchBarButton]
//        navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0.0, left: -15, bottom: 0, right: -10);
    }
    
    @objc func handleSearch() {
        print("search")
    }
    
    let settingsLauncher = SettingsLauncher()
    
    @objc func handleMore() {
        settingsLauncher.showSettings()
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.activateConstrainsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.activateConstrainsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let count = videos?.count {
//            return count
//        }
//
//        return 0
        
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        cell.video = videos?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 16:9 ratio for screen is best
        
        let imageViewheight = (view.frame.width - 16 - 16) * 9 / 16
        let cellHeight = imageViewheight + 16 + 88
        
        return CGSize(width: view.frame.width, height: cellHeight)
    }


}





