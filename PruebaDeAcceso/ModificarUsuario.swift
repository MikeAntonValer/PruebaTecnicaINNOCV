//
//  ModificarUsuario.swift
//  PruebaDeAcceso
//
//  Created by Miguel Angel Anton Valer on 4/12/22.
//

import UIKit

class ModificarUsuario: UIViewController {
    var user:User?
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var fechaDeNacimientoLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var botonModificar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTextField.text="\(user?.id ?? 0)"
        nameTextField.text=user?.name ?? "Nil"
        datePicker.setDate(transformacionFecha(fecha: user!.birthdate, formato: 0), animated: true)
        
        idLabel.frame=CGRect.init(x: view.frame.width/6, y: 90, width: view.frame.width*4/6, height: idLabel.frame.height)
        idTextField.frame=CGRect.init(x: view.frame.width/6, y: idLabel.frame.maxY+7, width: view.frame.width*4/6, height: idLabel.frame.height)
        idTextField.isEnabled=false
        
        nombreLabel.frame=CGRect.init(x: view.frame.width/6, y: idTextField.frame.maxY+20, width: view.frame.width*4/6, height: idLabel.frame.height)
        nameTextField.frame=CGRect.init(x: view.frame.width/6, y: nombreLabel.frame.maxY+7, width: view.frame.width*4/6, height: idLabel.frame.height)
        
        fechaDeNacimientoLabel.frame=CGRect.init(x: view.frame.width/6, y: nameTextField.frame.maxY+20, width: view.frame.width*4/6, height: idLabel.frame.height)
        datePicker.frame=CGRect.init(x: view.frame.width/6, y: fechaDeNacimientoLabel.frame.maxY+7, width: view.frame.width*4/6, height: idLabel.frame.height)
        
        botonModificar.frame=CGRect.init(x: view.frame.width/9, y: datePicker.frame.maxY+40, width: view.frame.width*7/9, height: idLabel.frame.height)
    }
    
    @IBAction func modificarUsuario(_ sender: Any) {
        user?.name=nameTextField.text
        user?.birthdate=datePicker.date.ISO8601Format()
        modificarUsers(user: user!)
        navigationController?.popViewController(animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
