//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Herrison Feres on 24/05/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var viSoundBar: UIImageView!
    @IBOutlet weak var slMusic: UISlider!
    @IBOutlet var btOptions: [UIButton]!
    @IBOutlet weak var ivQuiz: UIImageView!
    @IBOutlet weak var viTimer: UIView!
    
    var quizManager: QuizManager!
    var quizPlayer: AVAudioPlayer!
    var playerItem: AVPlayerItem!
    var backgroundMusicPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundMusic()
        viSoundBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizManager = QuizManager()
        getNewQuiz()
        startTimer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameOverViewController
        vc.score = quizManager.score
    }
    
    func playBackgroundMusic(){
        let musicURL = Bundle.main.url(forResource: "MarchaImperial", withExtension: "mp3")
        //let musicURL = URL(string: "URL DA NET")
        playerItem = AVPlayerItem(url: musicURL!)
        backgroundMusicPlayer = AVPlayer(playerItem: playerItem)
        backgroundMusicPlayer.volume = 0.1
        backgroundMusicPlayer.play()
        backgroundMusicPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: nil) { time in
            let percent = time.seconds / self.playerItem.duration.seconds
            self.slMusic.setValue(Float(percent), animated: true)
        }
    }
    
    func getNewQuiz(){
        let round = quizManager.generateRamdomQuiz()
        for i in 0..<round.options.count{
            btOptions[i].setTitle(round.options[i].name, for: .normal)
        }
        playQuiz()
    }
    
    func startTimer(){
        viTimer.frame = view.frame
        UIView.animate(withDuration: 60.0, delay: 0.0, options: .curveLinear) {
            self.viTimer.frame.size.width = 0
            self.viTimer.frame.origin.x = self.view.center.x
        } completion: { sucess in
            self.gameOver()
        }
    }
    
    @IBAction func playQuiz(){
        guard let round = quizManager.round else {return}
        ivQuiz.image = UIImage(named: "movieSound")
        if let url = Bundle.main.url(forResource: "quote\(round.quiz.number)", withExtension: "mp3"){
            do {
                self.quizPlayer = try AVAudioPlayer(contentsOf: url)
                quizPlayer.volume = 1
                quizPlayer.delegate = self
                quizPlayer.play()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func gameOver(){
        performSegue(withIdentifier: "gameOverSegue", sender: nil)
        quizPlayer.stop()
    }
    
    @IBAction func showHideSoundBar(_ sender: UIButton) {
        viSoundBar.isHidden = !viSoundBar.isHidden
    }
    
    @IBAction func changeMusicStatus(_ sender: UIButton) {
        if backgroundMusicPlayer.timeControlStatus == .paused {
            backgroundMusicPlayer.play()
            sender.setImage(UIImage(named: "pause"), for: .normal)
        }else{
            backgroundMusicPlayer.pause()
            sender.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    @IBAction func changeMusicTimer(_ sender: UISlider) {
        backgroundMusicPlayer.seek(to: CMTime(seconds: Double(sender.value) * playerItem.duration.seconds, preferredTimescale: 1))
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        quizManager.checkAnswer(sender.title(for: .normal)!)
        getNewQuiz()
    }
    
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        ivQuiz.image = UIImage(named: "movieSoundPause")
    }
}

