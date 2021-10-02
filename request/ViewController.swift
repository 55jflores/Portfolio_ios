//
//  ViewController.swift
//  request
//
//  Created by Jesus Flores on 3/27/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sep_len: UITextField!
    @IBOutlet weak var sep_wid: UITextField!
    @IBOutlet weak var pet_len: UITextField!
    @IBOutlet weak var pet_wid: UITextField!
   
    @IBOutlet weak var flower_label: UILabel!
    @IBOutlet weak var prob_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sep_len.delegate = self
        sep_wid.delegate = self
        pet_len.delegate = self
        pet_wid.delegate = self
    }
    
    func getData(from url:String) {
                
       let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("Something wrong")
                return
            }
        
            // Have data: Convert data
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch {
                print("Failed to convert")
            }
            
            guard let json = result else {
                return
            }
        
            DispatchQueue.main.async{
                self.flower_label.text = json.results.winningname
                
                self.prob_label.text = "\(String(json.results.winningprob)) %"
                print(json.results.winningname)
            
                print("Probability:")
                print(json.results.winningprob)
            }
            
        })

        task.resume()
        
    }
    
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    @IBAction func enter_button(_ sender: Any) {
        sep_len.endEditing(true)
        sep_wid.endEditing(true)
        pet_len.endEditing(true)
        pet_wid.endEditing(true)
        let url = "https://desolate-gorge-78560.herokuapp.com/test/\(sep_len.text!)/\(sep_wid.text!)/\(pet_len.text!)/\(pet_wid.text!)"
        //let url = "http://127.0.0.1:5000/test/\(sep_len.text!)/\(sep_wid.text!)/\(pet_len.text!)/\(pet_wid.text!)"
        getData(from:url)
        
        sep_len.text = ""
        sep_wid.text = ""
        pet_len.text = ""
        pet_wid.text = ""

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// Convert data from API to a class/struct
struct Response:Codable{
    let results: MyResult
}

struct MyResult: Codable{
    let winningname: String
    let winningprob: Float
}
