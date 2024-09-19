//
//  GameViewController.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 12.09.2024.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameSceneView: SKView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var startButton: CustomButton!
    @IBOutlet var toggleButtons: [UIButton]!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    
    lazy var popupView: PopupView = {
        let popup = PopupView(frame: self.view.bounds)
        popup.delegate = self
        return popup
    }()
    
    private var isGamePause = false {
        didSet {
            gameViewModel.pauseMusic(isGamePause)
            gameScene!.scene!.view!.isPaused = isGamePause
        }
    }
    
    private var gameScene: GameScene?
    
    private var gameViewModel: GameViewModel!
    private var isGameStarted: Bool = false {
        didSet { gameScene?.isGameStarted = isGameStarted }
    }
    var isGameOver: Bool = false {
        didSet {
            handleGameOver()
        }
    }
    private var balance = 0 {
        didSet { balanceLabel.text = "\(balance)" }
    }
    private var currentWinScore = 0 {
        didSet { totalScoreLabel.text = "\(currentWinScore)" }
    }
    var currentBet = 0 {
        didSet { betLabel.text = "\(currentBet)" }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameViewModel = GameViewModel()
        AudioManager.shared.playBackgroundMusic()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        balance = gameViewModel.balance
        currentWinScore = 0
        restartGame()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AudioManager.shared.stopSounds()
        AudioManager.shared.stopBackgroundMusic()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showSettingFromPlinko" else { return }
        guard let destination = segue.destination as? SettingViewController else { return }
        self.isGamePause = true
        destination.didTapCloseButton = {
            self.isGamePause = false
        }
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        isGameStarted = true
        startButton.isEnabled = false
        toggleButtons.forEach { $0.isEnabled = false }
    }
    
    @IBAction func toggleButtonTapped(_ sender: UIButton) {
        toggleButtons.forEach { $0.isEnabled.toggle() }
        
        switch sender.tag {
        case 0: decreaseBet()
        case 1: increaseBet()
        default: break
        }
        
        toggleButtons.forEach { $0.isEnabled.toggle() }
        startButton.isEnabled = true
    }
}

// MARK: Game Play
extension GameViewController {
    private func restartGame() {
        startButton.isEnabled = false
        toggleButtons.forEach { $0.isEnabled = true }
        isGameStarted = false
        gameScene?.restartGame()
    }
    
    private func setupGameScene() {
        let scene = GameScene(size: self.gameSceneView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        gameSceneView.presentScene(scene)
        
        gameScene = scene as GameScene
        gameScene?.vc = self
        
        gameSceneView.ignoresSiblingOrder = true
        gameSceneView.showsFPS = false
        gameSceneView.showsNodeCount = false
        gameSceneView.showsPhysics = true
    }
    
    private func handleGameOver() {
        guard isGameOver else { return }
        currentWinScore += currentBet
        balance += currentBet
        gameViewModel.balance = balance
        AudioManager.shared.playSounds("win")
        popupView.showPopupView(for: .plinko, at: self)
    }
}

// MARK: Bet Actions
extension GameViewController {
    private func decreaseBet() {
        if (currentBet - gameViewModel.betStep) > 0 {
            currentBet -= gameViewModel.betStep
            balance += gameViewModel.betStep
            gameScene?.currentBet = currentBet
        } else {
            toggleButtons.forEach { $0.isEnabled.toggle() }
        }
    }
    
    private func increaseBet() {
        if (currentBet + gameViewModel.betStep) <= balance && currentBet + gameViewModel.betStep <= gameViewModel.maxBet {
            currentBet += gameViewModel.betStep
            balance -= gameViewModel.betStep
            gameScene?.currentBet = currentBet
        } else {
            toggleButtons.forEach { $0.isEnabled.toggle() }
        }
    }
}

// MARK: PopupViewDelegate
extension GameViewController: PopupViewDelegate {
    func didButtonTouchDown() {
        restartGame()
    }
}
