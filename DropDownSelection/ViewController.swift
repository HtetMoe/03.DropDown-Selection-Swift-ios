//
//  ViewController.swift
//  DropDownSelection
//
//  Created by Htet Moe Phyu on 29/11/2021.

import UIKit

class DropDownCell : UITableViewCell {
}

class ViewController: UIViewController{
    
    //outlets Init
    @IBOutlet weak var mainCategorySelector: UIButton!
    @IBOutlet weak var subCategorySelector: UIButton!
    
    @IBOutlet weak var mainArrowImg: UIImageView!
    @IBOutlet weak var subArrowImg: UIImageView!
    
    
    //drop down Init
    let transparentView = UIView()
    let tableView      = UITableView()
    var selectedButton   = UIButton()
    var selectedArrowImg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //main category btn
        mainCategorySelector.layer.cornerRadius = 4
        mainCategorySelector.layer.borderWidth  = 1
        mainCategorySelector.layer.borderColor  = UIColor.darkGray.cgColor
        
        //sub category btn
        subCategorySelector.layer.cornerRadius = 4
        subCategorySelector.layer.borderWidth  = 1
        subCategorySelector.layer.borderColor  = UIColor.darkGray.cgColor
        
        //set up data to tb view
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(DropDownCell.self, forCellReuseIdentifier: "cell")
    }
    
    //main categ
    @IBAction func ButtonMainCategoryPressed(_ sender: UIButton) {
        selectedButton   = mainCategorySelector
        selectedArrowImg = mainArrowImg
        
        showTransparantDropDown(frames: selectedButton.frame, ddImage: nil,status: "main")
    }
    
    //sub categ
    @IBAction func ButtonSubCategoryPressed(_ sender: UIButton) {
        selectedButton   = subCategorySelector
        selectedArrowImg = subArrowImg
        
        showTransparantDropDown(frames: selectedButton.frame, ddImage: nil,status: "sub")
    }
    
    //MARK: setup Transparant dropDown view
    func showTransparantDropDown(frames : CGRect,ddImage : UIImageView?,status : String){
        
        selectedArrowImg.image = UIImage(named: "upArrow")
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: (frames.origin.y + frames.height), width: frames.width, height: 0)
        
        self.view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 5
        tableView.layer.borderColor  = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tableView.layer.borderWidth  = 1
        tableView.separatorStyle     = .none
        
        transparentView.backgroundColor = #colorLiteral(red: 0.1817716658, green: 0.1964741051, blue: 0.2005744576, alpha: 0)
        tableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDropDownView))
        transparentView.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.3) {
            self.transparentView.alpha = 0.5
            
            //can control dynamic height here based on status
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 4 , width: frames.width, height: 150)
        }
    }
    
    //MARK: hide dropDown view
    @objc func hideDropDownView(){
        self.selectedArrowImg.image = UIImage(named: "downArrow")
        let frames = selectedButton.frame
        
        self.transparentView.alpha = 0
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.3) {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }
    }
}

//MARK: extensions
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "category \(indexPath.row + 1)"
        cell.textLabel?.font = cell.textLabel?.font.withSize(14)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hideDropDownView()
       
    }
}

