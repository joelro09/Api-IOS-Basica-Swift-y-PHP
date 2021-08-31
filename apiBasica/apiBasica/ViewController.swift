//
//  ViewController.swift
//  apiBasica
//
//  Created by  on 8/30/21.
//  Copyright © 2021 PinkAndBrain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //Cear instancia de clase manejadora
    let datajsonUrlClass = JsonClass()
    
    //OUTLETS
    
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var apellidotext: UITextField!
    @IBOutlet weak var correoText: UITextField!
    
    @IBOutlet weak var mensajeLabel: UILabel!
    
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var buscarButton: UIButton!
    
    @IBOutlet weak var fechaaltaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mensajeLabel.textColor = .red
    }

    @IBAction func buscarAccion(_ sender: Any) {
               //Borrar contenido de todos los text
                nombreText.text = ""
                apellidotext.text = ""
                correoText.text = ""
                
                let id_usuario = idText.text
                let nombre = "otro_parametro"
                
                
                if id_usuario == ""{
                    return
                }
                
                let datos_a_enviar = ["id_usuario": id_usuario!,"nombre": nombre] as NSMutableDictionary
                
                datajsonUrlClass.arrayFromJson(url: "ios/webservice1.php", datos_enviados: datos_a_enviar){ (array_respuesta) in
                    DispatchQueue.main.async {
                        let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                        
                        if let error = diccionario_datos.object(forKey: "error_mensaje") as! String?{
                            self.mensajeLabel.text = error
                        }
                        
                        if let nombre = diccionario_datos.object(forKey: "nombre") as! String?{
                            self.nombreText.text = nombre
                        }
                        
                        if let apellido = diccionario_datos.object(forKey: "apellido") as! String?{
                            self.apellidotext.text = apellido
                        }
                        
                        if let correo = diccionario_datos.object(forKey: "correo") as! String?{
                            self.correoText.text = correo
                        }
                        
                        if let fecha_alta = diccionario_datos.object(forKey: "fecha_alta") as! String?{
                            self.fechaaltaLabel.text = fecha_alta
                        }
                        
                    }
                }
                
            }
                
            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
            }
        

    }



