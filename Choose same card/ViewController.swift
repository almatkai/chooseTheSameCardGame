//
//  ViewController.swift
//  Choose same card
//
//  Created by Almat Kairatov on 07.06.2022.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        // #007600
        // 007600

        let length = hexSanitized.count

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

class ViewController: UIViewController {

    var range = 11
    var flipped = 0
        
    let emojies = ["🐼", "🐼", "🎾", "🎾", "🥶", "🥶", "🧠", "🧠", "📀", "📀", "🕐", "🕐"/*, "🇰🇿", "🇰🇿", "🛖","🛖","🚁", "🚁", "🥇", "🥇"*/]
    var number = [0,1,2,3,4,5,6,7,8,9,10,11/*,13,14,15,16,17,18,19,20*/]
    var attachedEmoji = ["", "", "", "", "", "", "", "", "", "", "", "",]
        
    var attempt = 0 {
        didSet{
            attempts.text = "\(attempt)"
        }
    }
    
    
    @IBOutlet weak var attempts: UILabel!
    
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    @IBAction func cards(_ sender: UIButton) {
        var tittle = sender.currentTitle
        var openedButtons: [UIButton] = []

        if sender.currentTitle == nil || tittle == "" {
            var i = 0
            
            for button in buttonCollection {

                if button == sender {

                    flipped += 1
                    if attachedEmoji[i] == "" {

                        var index = Int.random(in: 0...range)
                        range -= 1

                        sender.setTitle(emojies[number[index]], for: .normal)
                        sender.backgroundColor = UIColor.white

                        attachedEmoji[i] = emojies[number[index]]
                        number.remove(at: index)
                    } else {

                        sender.setTitle(attachedEmoji[i], for: .normal)
                        sender.backgroundColor = UIColor.white
                    }

                    attempt += 1
                    attempts.text = "\(attempt)"

                    break
                }
                i += 1
            }
        }
        if flipped == 2 {

            for button in buttonCollection {

                if button.currentTitle != nil && button.currentTitle != ""{
                    openedButtons.append(button)
                }

                if(openedButtons.count == 2){

                    perform(#selector(flipCards), with: openedButtons, afterDelay: 1)

                    buttonCollection.map{
                        $0.isEnabled = false
                    }

                    perform(#selector(enableButton), with: buttonCollection, afterDelay: 0.5)
                    break
                }
            }
            flipped = 0
        }

    }
    @objc private func flipCards(openedButtons:[UIButton]){

        if openedButtons[0].currentTitle == openedButtons[1].currentTitle{

            for button in openedButtons {

                button.setTitle("", for: .normal)
                button.isHidden = true
            }
        }
        else{

            for button in openedButtons {

                button.setTitle("", for: .normal)
                button.backgroundColor = UIColor(hex: "#0074e2")
            }
        }
    }
    @objc func enableButton() {

        buttonCollection.map{
            $0.isEnabled = true
        }
    }
}

