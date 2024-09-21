//
//  QuizViewController.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 14.09.2024.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var slotView: SlotView!
    @IBOutlet weak var wheelView: WheelView!
    @IBOutlet var labelViews: [GradientView]!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var toggleButtons: [UIButton]!
    @IBOutlet weak var spinButton: CustomButton!
    
    lazy var popupView: PopupView = {
        let popup = PopupView(frame: self.view.bounds)
        popup.delegate = self
        return popup
    }()
    
    var gameType: GameType = .roulette
    
    private var gameViewModel: GameViewModel!
    
    private var balance = 0 {
        didSet { balanceLabel.text = "\(balance)" }
    }
    private var currentWinScore = 0 {
        didSet { scoreLabel.text = "\(currentWinScore)" }
    }
    private var currentBet = 0 {
        didSet { betLabel.text = "\(currentBet)" }
    }
    
    private var isGamePause = false {
        didSet {
            gameViewModel.pauseMusic(isGamePause)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        spinButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameViewModel = GameViewModel()
        AudioManager.shared.playBackgroundMusic()
        updateGameViews()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        restartGame()
        balance = gameViewModel.balance
        currentWinScore = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AudioManager.shared.stopSounds()
        AudioManager.shared.stopBackgroundMusic()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showSettingFromSlot" else { return }
        guard let destination = segue.destination as? SettingViewController else { return }
        self.isGamePause = true
        destination.didTapCloseButton = {
            self.isGamePause = false
        }
    }
    
    @IBAction func spinButtonTapped(_ sender: UIButton) {
        sender.isEnabled.toggle()
        toggleButtons.forEach { $0.isEnabled.toggle() }
        switch gameType {
        case .slot:
            slotView.spinSlots { [weak self] in
                self?.checkSlotGameResult()
                self?.toggleButtons.forEach { $0.isEnabled.toggle() }
            }
        case .roulette:
            wheelView.speenWheel(gameViewModel: gameViewModel) { [weak self] in
                AudioManager.shared.stopSounds()
                if let stoppedIndex = self?.wheelView.getStoppedIndex() {
                    self?.checkRouletteGameResult(at: stoppedIndex)
                    self?.toggleButtons.forEach { $0.isEnabled.toggle() }
                }
            }
        case .plinko:
            return
        }
    }
    
    @IBAction func toggleButtonTapped(_ sender: UIButton) {
        toggleButtons.forEach { $0.isEnabled.toggle() }
        let initialBet = currentBet
        
        switch sender.tag {
        case 0: decreaseBet()
        case 1: increaseBet()
        case 2: maxBet(initialBet: initialBet)
        default: break
        }
        
        toggleButtons.forEach { $0.isEnabled.toggle() }
        spinButton.isEnabled = currentBet > 0
    }
}

// MARK: Game Play
extension QuizViewController {
    private func restartGame() {
        currentBet = 0
        AudioManager.shared.stopSounds()
    }
    
    private func checkSlotGameResult() {
        let selectedRows = (0..<slotView.dataArray.count).map { slotView.slotPickerView.selectedRow(inComponent: $0) }
        let firstValue = slotView.dataArray[0][selectedRows[0]]
        let matchCount = selectedRows.enumerated().filter { index, row in
            slotView.dataArray[index][row] == firstValue
        }.count
        
        switch matchCount {
        case 3...5:
            let reward = currentBet / 5 * matchCount
            handleWin(reward: reward)
        default:
            Task {
                AudioManager.shared.playSounds("lose")
                gameViewModel.balance = balance
                try await Task.sleep(nanoseconds: 1_000_000_000)
                restartGame()
            }
        }
    }
    
    private func checkRouletteGameResult(at index: Int) {
        switch gameViewModel.rouletteRewards[index].cellType {
        case .lose:
            AudioManager.shared.playSounds("lose")
            gameViewModel.balance = balance
            restartGame()
        default:
            handleWin(reward: gameViewModel.rouletteRewards[index].score)
        }
    }
    
    private func handleWin(reward: Int) {
        AudioManager.shared.playSounds("win")
        balance += reward
        gameViewModel.balance = balance
        currentWinScore += reward
        popupView.showPopupView(for: gameType, at: self)
    }
}

// MARK: View Updater
extension QuizViewController {
    private func updateGameViews() {
        slotView.isHidden = gameType != .slot
        wheelView.isHidden = gameType != .roulette
        slotView.loadData()
        if gameType == .slot {
            slotView.spinSlots { [self] in
                toggleButtons.forEach { $0.isEnabled = true }
            }
        }
    }
    
    private func setupUI() {
        backgroundImage.image = UIImage(named: gameType.bgName)
        labelViews.forEach {
            $0.dropInnerShadow(to: [.top])
            $0.layer.masksToBounds = true
        }
    }
}

// MARK: Bet Actions
extension QuizViewController {
    private func decreaseBet() {
        guard (currentBet - gameViewModel.betStep) >= 0 else {
            return
        }
        currentBet -= gameViewModel.betStep
        balance += gameViewModel.betStep
    }
    
    private func increaseBet() {
        guard (currentBet + gameViewModel.betStep) <= balance &&
                currentBet + gameViewModel.betStep <= gameViewModel.maxBet else {
            return
        }
        currentBet += gameViewModel.betStep
        balance -= gameViewModel.betStep
    }
    
    private func maxBet(initialBet: Int) {
        guard  balance >= gameViewModel.maxBet else {
            return
        }
        currentBet = gameViewModel.maxBet
        balance -= (gameViewModel.maxBet - initialBet)
    }
}

// MARK: PopupViewDelegate
extension QuizViewController: PopupViewDelegate {
    func didButtonTouchDown() {
        restartGame()
    }
}
