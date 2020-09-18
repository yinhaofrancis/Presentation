//
//  FELiveDisplayViewController.swift
//  Presentation
//
//  Created by hao yin on 2020/9/7.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit
import AVKit


@objc public class FELiveDisplayViewController: UIViewController {
    
    var netState:NetworkStateObserver?
    let videoLayer:AVPlayerLayer = AVPlayerLayer()
    
    lazy var pauseImage: UIImage = {
        let pimg = PresentImage(size: CGSize(width: 13, height: 17)).hasScale(scale: UIScreen.main.scale).hasAlpha(alpha: true)
        let img = pimg.draw { (pi) in
            pi.context?.move(to: CGPoint(x: 2, y: 2))
            pi.context?.addLine(to: CGPoint(x: 2, y: 13))
            pi.context?.move(to: CGPoint(x: 11, y: 2))
            pi.context?.addLine(to: CGPoint(x: 11, y: 13))
            pi.context?.setStrokeColor(UIColor.white.cgColor)
            pi.context?.setLineCap(.round)
            pi.context?.setLineWidth(4)
            pi.context?.strokePath()
        }
        if(img != nil){
            return UIImage(cgImage: img!, scale: UIScreen.main.scale, orientation: .up)
        }else{
            return UIImage()
        }
    }()
    lazy var startImage: UIImage = {
        let pimg = PresentImage(size: CGSize(width: 13, height: 17)).hasScale(scale: UIScreen.main.scale).hasAlpha(alpha: true)
        let img = pimg.draw { (pi) in
            pi.context?.move(to: CGPoint(x: 0, y: 2))
            pi.context?.addLine(to: CGPoint(x: 0, y: 15))
            pi.context?.addLine(to: CGPoint(x: 13, y: 8.5))
            pi.context?.setFillColor(UIColor.white.cgColor)
            pi.context?.fillPath()
        }
        if(img != nil){
            return UIImage(cgImage: img!, scale: UIScreen.main.scale, orientation: .up)
        }else{
            return UIImage()
        }
    }()
    
    lazy var fullScreen: UIImage = {
        let pimg = PresentImage(size: CGSize(width: 18, height: 18)).hasScale(scale: UIScreen.main.scale).hasAlpha(alpha: true)
        let img = pimg.draw { (pi) in
            let bspath = UIBezierPath()
            bspath.move(to: CGPoint(x: -9.01, y: -9.01))
            bspath.addLine(to: CGPoint(x: -2.89, y: -8.89))
            bspath.addLine(to: CGPoint(x: -4.89, y: -6.88))
            bspath.addLine(to: CGPoint(x: -1.01, y: -2.99))
            bspath.addLine(to: CGPoint(x: -3.01, y: -0.99))
            bspath.addLine(to: CGPoint(x: -6.89, y: -4.88))
            bspath.addLine(to: CGPoint(x: -8.9, y: -2.88))
            bspath.addLine(to: CGPoint(x: -9.02, y: -9.01))
            bspath.addLine(to: CGPoint(x: -9.01, y: -9.01))
            bspath.close()
            pi.context?.translateBy(x: 9, y: 9)
            pi.context?.setFillColor(UIColor.white.cgColor)
            for i in 0 ..< 4{
                pi.context?.rotate(by: CGFloat.pi / 2 * CGFloat(i))
                pi.context?.addPath(bspath.cgPath)
                pi.context?.fillPath()
            }
        }
        if(img != nil){
            return UIImage(cgImage: img!, scale: UIScreen.main.scale, orientation: .up)
        }else{
            return UIImage()
        }
    }()
    
    lazy var pauseButton:UIButton = {
        let button = UIButton()
        button.setImage(self.pauseImage, for: .selected)
        button.setImage(self.startImage, for: .normal)
        button .addTarget(self, action: #selector(toPlay), for: .touchUpInside)
        return button
    }()
    
    lazy var fullScreemButton:UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(toFullscreen), for: .touchUpInside)
        button.setImage(self.fullScreen, for: .normal)
        return button
    }()
    let bottomMaskLayer:CAGradientLayer = {
        let blayer = CAGradientLayer()
        blayer.colors = [UIColor.black.withAlphaComponent(0).cgColor,UIColor.black.withAlphaComponent(0.75).cgColor]
        blayer.locations = [0,1]
        blayer.startPoint = CGPoint.zero
        blayer.endPoint = CGPoint(x: 0, y: 1)
        return blayer
    }()
    let topMaskLayer:CAGradientLayer = {
        let blayer = CAGradientLayer()
        blayer.colors = [UIColor.black.withAlphaComponent(0.75).cgColor,UIColor.black.withAlphaComponent(0).cgColor]
        blayer.locations = [0,1]
        blayer.startPoint = CGPoint.zero
        blayer.endPoint = CGPoint(x: 0, y: 1)
        return blayer
    }()
    public var loadingView:UIView = {
        let load = UIActivityIndicatorView(style: .whiteLarge)
        load.startAnimating()
        load.hidesWhenStopped = true
        return load
    }()
    
    public lazy var failView:UIView = {
        let load = UIView()
        self.view.addSubview(load)
        self.view.bringSubviewToFront(load)
        let tra = [load.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
         load.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
         load.topAnchor.constraint(equalTo: self.view.topAnchor),
         load.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
        load.translatesAutoresizingMaskIntoConstraints = false
        load.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view .addConstraints(tra)
        
        let stack = UIStackView()
        load.addSubview(stack)
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        load.addSubview(stack)
        let cons = [stack.centerYAnchor.constraint(equalTo: load.centerYAnchor),stack.centerXAnchor.constraint(equalTo: load.centerXAnchor)]
        load.addConstraints(cons)
        
        let l = UILabel()
        stack.addArrangedSubview(l)
        l.text = "网络中断请重试"
        l.font = UIFont .systemFont(ofSize: 14, weight: .semibold)
        l.textColor = UIColor.white
        
        let button = UIButton();
        button.setTitleColor(UIColor(red: 0, green: 122 / 255.0, blue: 1, alpha: 1), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false;
        button.addConstraints([button.widthAnchor.constraint(equalToConstant: 90),button.heightAnchor.constraint(equalToConstant: 28)])
        button.layer.cornerRadius = 14;
        button.layer.borderColor = UIColor(red: 0, green: 122 / 255.0, blue: 1, alpha: 1).cgColor
        button.layer.borderWidth = 1;
        button.layer.masksToBounds = true
        button .setTitle("重试", for: .normal);
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        stack.addArrangedSubview(button)
        button .addTarget(self, action: #selector(reload), for: .touchUpInside)
        
        return load
    }()
     public lazy var waitWifiView:UIView = {
        let load = UIView()
        self.view.addSubview(load)
        self.view.bringSubviewToFront(load)
        let tra = [load.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                   load.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                   load.topAnchor.constraint(equalTo: self.view.topAnchor),
                   load.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
        load.translatesAutoresizingMaskIntoConstraints = false
        load.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view .addConstraints(tra)
        
        let stack = UIStackView()
        load.addSubview(stack)
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        load.addSubview(stack)
        let cons = [stack.centerYAnchor.constraint(equalTo: load.centerYAnchor),stack.centerXAnchor.constraint(equalTo: load.centerXAnchor)]
        load.addConstraints(cons)
        
        let l = UILabel()
        stack.addArrangedSubview(l)
        l.text = "当前正使用移动网络观看"
        l.font = UIFont .systemFont(ofSize: 14, weight: .semibold)
        l.textColor = UIColor.white
        
        
        let buttonStack = UIStackView()
        stack .addArrangedSubview(buttonStack)
        buttonStack.spacing = 20
        let button = UIButton();
        button.setTitleColor(UIColor(red: 0, green: 122 / 255.0, blue: 1, alpha: 1), for: .normal)
        button.addConstraints([button.widthAnchor.constraint(equalToConstant: 90),button.heightAnchor.constraint(equalToConstant: 28)])
        button.layer.cornerRadius = 14;
        button.layer.borderColor = UIColor(red: 0, green: 122 / 255.0, blue: 1, alpha: 1).cgColor
        button.layer.borderWidth = 1;
             
        button.layer.masksToBounds = true
        button .setTitle("继续播放", for: .normal);
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        buttonStack.addArrangedSubview(button)
        button .addTarget(self, action: #selector(continueMobile), for: .touchUpInside)
        
        let button3 = UIButton();
        button3.setTitleColor(UIColor.white, for: .normal)
        //        button.translatesAutoresizingMaskIntoConstraints = false;
        button3.addConstraints([button3.widthAnchor.constraint(equalToConstant: 90),button3.heightAnchor.constraint(equalToConstant: 28)])
        button3.layer.cornerRadius = 14;
        button3.backgroundColor = UIColor(red: 0, green: 122 / 255.0, blue: 1, alpha: 1)
        button3.layer.masksToBounds = true
        button3 .setTitle("退出直播", for: .normal);
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        buttonStack.addArrangedSubview(button3)
        button3 .addTarget(self, action: #selector(cancel), for: .touchUpInside)
            
        return load
        }()
    var videoPlayer:AVPlayer?
    public var mobileNetPay:Bool = false
    var urls:[String:URL] = [:]
    public private(set) var urlChanel:String = ""
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.addSublayer(self.videoLayer)
        self.videoLayer.backgroundColor = UIColor.black.cgColor
        do{
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().setCategory(.playback)
        }catch{
            
        }
        self.view.addSubview(self.pauseButton)
        let a = [self.pauseButton.leftAnchor.constraint(equalTo: self.view.leftAnchor),
         self.pauseButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
        self.view.addConstraints(a)
        self.pauseButton.translatesAutoresizingMaskIntoConstraints = false
        self.pauseButton.addConstraints([self.pauseButton.widthAnchor.constraint(equalToConstant: 44),self.pauseButton.heightAnchor.constraint(equalToConstant: 44)]);
        
        self.view.addSubview(self.fullScreemButton)
        let f = [self.fullScreemButton.rightAnchor.constraint(equalTo: self.view.rightAnchor),
         self.fullScreemButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
        self.view.addConstraints(f)
        self.fullScreemButton.translatesAutoresizingMaskIntoConstraints = false
        self.fullScreemButton.addConstraints([self.fullScreemButton.widthAnchor.constraint(equalToConstant: 44),self.fullScreemButton.heightAnchor.constraint(equalToConstant: 44)]);
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.videoLayer.frame = self.view.bounds
        self.bottomMaskLayer.frame = CGRect(x: 0, y: self.view.bounds.maxY - 44, width: self.view.bounds.width, height: 44)
        self.topMaskLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 68)
        self.view.layer.addSublayer(self.bottomMaskLayer)
        self.view.layer.addSublayer(self.topMaskLayer)
        self.view.bringSubviewToFront(self.pauseButton)
        self.view.bringSubviewToFront(self.fullScreemButton)
    }
    public override func viewWillAppear(_ animated: Bool) {
        if(self.videoPlayer != nil && self.videoLayer.player == nil) {
            self.videoLayer.player = self.videoPlayer
            self.videoPlayer?.pause()
            self.pauseButton.isSelected = false
        }
    }
    @objc public func add(url:String?,name:String?){
        if let us = url, let n = name{
            if let rurl = URL(string: us){
                self.urls[n] = rurl;
                if(self.urlChanel.count == 0){
                    self.urlChanel = n
                }
                self.play(rurl: rurl)
            }
        }
    }
    func observerPlayer(play:AVPlayer){
        play.addObserver(self, forKeyPath: "status", options: .new, context: nil)
    }
    func removePlayer(play:AVPlayer?){
        play?.removeObserver(self, forKeyPath: "status")
        self.videoPlayer = nil
        self.videoLayer.player = nil
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(context == nil){
            if(keyPath == "status"){
                if let vp = self.videoPlayer{
                    if(vp.status == .readyToPlay){
                        self.stopLoading()
                        self.playVideo()
                    }
                }
            }
        }
    }
   
    func play(rurl:URL){
        observerUrl(rurl: rurl)
        if(self.netState?.netState == .some(.WiFi) || self.mobileNetPay){
            videoPlayer = AVPlayer(url: rurl)
            self.startLoading()
            self.videoLayer.player = self.videoPlayer
            if let p = self.videoPlayer {
                self.observerPlayer(play: p)
            }
        }else if self.netState?.netState == .some(.other){
            self.loadNetwork4G()
            self.stopLoading()
        }else{
            self.loadNetworkFail()
            self.stopLoading()
        }
    }
    func observerUrl(rurl:URL){
        if let n = self.netState {
            n.stopNotifier()
        }
        
        self.netState = NetworkStateObserver(url: rurl, change: { [weak self] (s) in
            if self?.videoPlayer?.status == .readyToPlay && s == .WiFi{
                self?.playVideo()
            }else if self?.videoPlayer?.status == .readyToPlay && s == .other{
                if self?.mobileNetPay == true{
                    self?.playVideo()
                }else{
                    self?.loadNetwork4G()
                    self?.videoPlayer?.pause()
                }
            }else if s == .Noreach{
                self?.loadNetworkFail()
                self?.videoPlayer?.pause()
            }else{
                
            }
        });
        self.netState?.startNotifer()
    }
    func loadNetworkFail(){
        self.failView.isHidden = false
    }
    func removeNetworkFail(){
        self.failView.isHidden = true
    }
    func loadNetwork4G(){
        self.waitWifiView.isHidden = false
    }
    func removeNetwork4G(){
        self.waitWifiView.isHidden = true;
    }
    func startLoading(){
        let loadding = self.loadingView
        self.view .addSubview(loadding)
        self.view.bringSubviewToFront(loadding)
        loadding.translatesAutoresizingMaskIntoConstraints = false
        let cons = [loadding.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),loadding.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)]
        self.view .addConstraints(cons)
    }
    func stopLoading(){
        self.loadingView.removeFromSuperview()
    }
    func playVideo(){

        self.videoPlayer?.play()
        self.pauseButton.isSelected = true
        self.removeNetworkFail()
        self.removeNetwork4G()
    }
    @objc func reload(){
        self.startLoading()
        self.removeNetworkFail()
        self.removePlayer(play: self.videoPlayer)
        if let u = self.urls[self.urlChanel]{
           self.play(rurl: u)
        }
    }
    @objc func cancel(){
        
    }
    @objc func toFullscreen(){
        let a = AVPlayerViewController()
        a.player = AVPlayer(playerItem: self.item)
        

        self.present(a, animated: true, completion:{
            a.player?.play()
        })
        
        
    }
    let item = AVPlayerItem(url: URL(string: "http://hlstct.douyucdn2.cn/dyliveflv3/3921570rlBduDbuc.m3u8?txSecret=bc0f3f1ad19d3ef8e69de2266c6aab77&txTime=5f585ca5&token=cpg-FIVEEPlay-0-3921570-30983e2ca1b09fce6d7f10f424b68a10&did=&origin=ws&vhost=play3&tp=258d5c49")!)
    @objc func toPlay(){
        self.pauseButton.isSelected = !self.pauseButton.isSelected
        if self.videoLayer.player == nil {
            self.videoLayer.player = self.videoPlayer
        }
        if(self.pauseButton.isSelected){
            self.videoPlayer?.play()
            
        }else{
            self.videoPlayer?.pause()
        }
        
    }
    
    @objc func continueMobile(){
        self.mobileNetPay = true
        self.removeNetwork4G()
        self.reload()
    }
}
