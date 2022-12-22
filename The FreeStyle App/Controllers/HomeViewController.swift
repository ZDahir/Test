//
//  ViewController.swift
//  The FreeStyle App
//
//  Created by Zaid Dahir on 2021-07-18.
//  Copyright © 2021 Zaid Dahir. All rights reserved.
//

import UIKit
import Speech

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        ryhmes_TableView.delegate = self
        ryhmes_TableView.dataSource = self
        btn_start.setTitle("Press to start Freestyle.", for: .normal)
        btn_start.backgroundColor = .systemOrange
        btn_start.layer.cornerRadius = 10
        btn_start.clipsToBounds = true
        text_View.layer.cornerRadius = 10
        text_View.clipsToBounds = true
        ryhmes_TableView.layer.cornerRadius = 10
        ryhmes_TableView.clipsToBounds = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        

    }
    
   // let client = DataMuseClient()
        
    var theRyhmesArray = [Words]()
    
    var db:DBHelper = DBHelper()
            
    //MARK: - OUTLET PROPERTIES
    @IBOutlet weak var lb_speech: UILabel!
    
    @IBOutlet weak var ryhmes_TableView: UITableView!
    @IBOutlet weak var text_View: UITextView!
    @IBOutlet weak var btn_start: UIButton!
    
    //MARK: - Local Properties
    let audioEngine = AVAudioEngine()
    let speechReconizer : SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task : SFSpeechRecognitionTask!
    var isStart : Bool = false
    
    func startSpeechRecognization(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error {
            alertView(message: "Error comes here for starting the audio listner =\(error.localizedDescription)")
        }
        
        guard let myRecognization = SFSpeechRecognizer() else {
            self.alertView(message: "Recognization is not allow on your local")
            return
        }
        
        if !myRecognization.isAvailable {
            self.alertView(message: "Recognization is free right now, Please try again after some time.")
        }
        
        task = speechReconizer?.recognitionTask(with: request, resultHandler: { (response, error) in
            guard let response = response else {
                if error != nil {
                    // self.alertView(message: error.debugDescription)
                }else {
                    self.alertView(message: "Problem in giving the response")
                }
                return
            }
            
            let message = response.bestTranscription.formattedString
            print("Message : \(message)")
            self.text_View.text = message
            let sentence = message
            let theWord = sentence.byWords
            let lastWord = theWord.last
            
            
            if Reachability.isConnectedToNetwork() {

                self.apiRequest(with: String(lastWord!))
                
            }else{
                self.alertView(message: "Please check your internet connection.")

            }
            
//            self.client.wordsThatRhyme(with: String(lastWord!)) { (words, error) in
//                DispatchQueue.main.async {
//
//
//                    var ryhmesArray = [String]()
//                    for thing in words! {
//                        ryhmesArray.append(thing.word!)
//                    }
//                    self.theRyhmesArray = ryhmesArray
//                   self.ryhmes_TableView.reloadData()
//                }
//            }
        })
    }
    
    //MARK: UPDATED FUNCTION
    
    func cancelSpeechRecognization() {
        task.finish()
        //task.cancel()
        task = nil
        
        request.endAudio()
        audioEngine.stop()
        //audioEngine.inputNode.removeTap(onBus: 0)
        
        //MARK: UPDATED
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
    
    @IBAction func btn_start_stop(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
        //MARK:- Coding for start and stop sppech recognization...!
        isStart = !isStart
        if isStart {
            startSpeechRecognization()
            btn_start.setTitle("Press To End Session.", for: .normal)
            btn_start.backgroundColor = .systemGreen
            btn_start.isEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.btn_start.isEnabled = true
            }
            //isStart = true
        }else {
            cancelSpeechRecognization()
            btn_start.setTitle("Start Session", for: .normal)
            btn_start.backgroundColor = .systemOrange
            //isStart = false

        }
        }else{
            alertView(message: "Please check your internet connection.")

        }
    }
}



extension StringProtocol { // for Swift 4 you need to add the constrain `where Index == String.Index`
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, Save_Delegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theRyhmesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = theRyhmesArray[indexPath.row].word
        return cell
    }
    
    @IBAction func savedFromHome() {
        
        let dialogSave = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Dialog_SaveVerse") as! Dialog_SaveVerse
        dialogSave.modalPresentationStyle = .overCurrentContext
        dialogSave.modalTransitionStyle = .crossDissolve
        dialogSave.delegate = self
        self.present(dialogSave, animated: true)
        

    }
    
    func verseSaved(verseTitle: String) {
        db.insert(title: verseTitle, desc: text_View.text, isFavorite: 0)
        alertView(message: "Verse Saved")
    }
    
    func date() -> String {
        
        
        // Create Date
        let date = Date()

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"

        // Convert Date to String
        return dateFormatter.string(from: date)

    }
         func getTodayString() -> String{

            let date = Date()
            let calender = Calendar.current
            let components = calender.dateComponents([.year,.month,.day,.hour,.minute], from: date)

            let year = components.year
            let month = components.month
            let day = components.day
            let hour = components.hour
            let minute = components.minute
          

            let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " at " + String(hour!)  + ":" + String(minute!)

            return today_string
        }
}

extension UIViewController{
    func alertView(message : String) {
        let controller  = UIAlertController.init(title: message, message: nil, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in controller.dismiss(animated: true, completion: nil)
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}

 //MARK: - API
extension HomeViewController{
    
    func apiRequest(with: String){
        
       let jsonUrlString = "https://api.datamuse.com/words?rel_rhy=\(with)"
        
        guard let url = URL(string: jsonUrlString)  else
            {return}
        
        URLSession.shared.dataTask(with: url)   { (data, response, error) in
                            
            if (error == nil && response != nil && data?.count != 0)    {
                
                let decoder = JSONDecoder()
                
                do {
                    //self.theRyhmesArray = []
                    self.theRyhmesArray = try decoder.decode([Words].self, from: data!)
                    
                    DispatchQueue.main.async {
                        print(self.theRyhmesArray.count)
                        self.ryhmes_TableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            
            }

        }.resume()
        

    }
    
    
}
