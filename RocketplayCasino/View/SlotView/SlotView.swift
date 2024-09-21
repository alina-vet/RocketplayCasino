//
//  SlotView.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 14.09.2024.
//

import UIKit

class SlotView: UIView {

    @IBOutlet weak var slotPickerView: UIPickerView!
    
    var dataArray = [[Int](), [Int](), [Int](), [Int](), [Int]()]
    let amountOfRowsInComponent = 100
    var slotImageArray: [String] {
        return (0...6).map { "item_\($0)" }
    }
    
    var pickerRowSize: CGFloat {
        return slotPickerView.frame.width / 5.2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let xibView = Bundle.main.loadNibNamed("SlotView",
                                               owner: self,
                                               options: nil)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
        
        setupPickerView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.subviews.filter { $0.layer.name == "dropShadow" }
            .forEach { $0.layer.removeFromSuperlayer() }
        
        self.dropShadow(color: .white,
                        blur: 25,
                        opacity: 1,
                        offSet: CGSize(width: 0,
                                       height: 4))
    }
    
    private func setupPickerView() {
        slotPickerView.delegate = self
        slotPickerView.dataSource = self
        slotPickerView.subviews.forEach { $0.backgroundColor = .clear }
    }
    
    func loadData() {
        dataArray = [[Int](), [Int](), [Int](), [Int](), [Int]()]
        for i in 0..<dataArray.count {
            for _ in 0...amountOfRowsInComponent {
                dataArray[i].append(Int.random(in: 0...slotImageArray.count - 1))
            }
        }
    }
    
    func spinSlots(completion: @escaping (() -> Void)) {
        AudioManager.shared.playSounds("rattle")
        let delayIncrement = 0.2
        for i in 0..<dataArray.count {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayIncrement * Double(i)) {
                self.slotPickerView.selectRow(Int.random(in: 10...90), inComponent: i, animated: true)
            }
        }
        AudioManager.shared.stopSounds()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
}

extension SlotView: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataArray.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return amountOfRowsInComponent
    }
}

extension SlotView: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerRowSize
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerRowSize
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerImageView = UIImageView()
        pickerImageView.image = UIImage(named: slotImageArray[dataArray[component][row]])
        pickerImageView.frame = CGRect(origin: .zero,
                                       size: CGSize(width: pickerRowSize * 0.9,
                                                    height: pickerRowSize * 0.9))
        pickerImageView.contentMode = .scaleAspectFit
        
        switch dataArray[component][row] {
        case 0:
            pickerImageView.dropShadow(color: .red, blur: 6, opacity: 1)
        case 1:
            pickerImageView.dropShadow(color: .green, blur: 6, opacity: 1)
        case 3:
            pickerImageView.dropShadow(color: .yellow, blur: 6, opacity: 1)
        default:
            pickerImageView.dropShadow(color: .white, blur: 6, opacity: 1)
        }
        
        return pickerImageView
    }
}
