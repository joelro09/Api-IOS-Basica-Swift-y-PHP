//
//  JsonClass.swift
//  apiBasica
//
//  Created by  on 8/30/21.
//  Copyright © 2021 PinkAndBrain. All rights reserved.
//

import Foundation
import UIKit

class JsonClass: NSObject{
    
    //constantes de nuestra clase
    let urlBase = "http://192.168.0.75:8888/"//url del servidor remoto
    
    let key = "123456abcde"//key autoriza a nuestra app para extraer datos
    let model = UIDevice.current.model//modelo del dispositivo
    let iddevice = UIDevice.current.identifierForVendor!.uuidString
    let langStr = Locale.current.languageCode!
    let fecha = "2021-08/27"
    
    
    //funcion recibe el array JSON desde el servidor remoto y lo convierte en array tipo NSArray
    /*parametros de entrada son:
     URL -> nombre del archivo .php que va procesar nuestra solicitud
     datos_enviados -> array de datos que vamos enviar via POST
     */
    
    func arrayFromJson(url:String, datos_enviados:NSMutableDictionary, comlectionHandler: @escaping(NSArray?) -> Void){
        //concatenamos nuestra url base con nuestro archivo .php que va procesar la solicitud
        let url = URL(string: "\(urlBase)/\(url)")!
        //convertimos la constante url a tipo URLRequest
        var request = URLRequest(url: url)
        
        //establecemos las cabeceras de la peticion JSON estandár
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"//Puede ser GEt pero por seguridad mejor POST
         
        datos_enviados["key"] = key
         datos_enviados["lenguaje"] = langStr
         datos_enviados["model"] = model
         datos_enviados["iddevice"] = iddevice
        datos_enviados["fecha"] = fecha
        
        //Convertimos el aray en formato JSON antes de ser enviada
        request.httpBody = try! JSONSerialization.data(withJSONObject: datos_enviados)
        
        //realizamos la peticion al server remoto
        
        let task = URLSession.shared.dataTask(with: request) { datos_recibidos, response, error in
            
            if error != nil{//detectamos un error y devolvemos array vacio
                comlectionHandler(nil)
            }
            else{
                //tratamos de convertir la respuesta en array
                do{
                    //imprimimos en consola los datos enviados y los dtos recibidos en modo debug
                    print("datos recibidos: \(String(describing: String(data: datos_recibidos!,encoding: .utf8))) - datos enviados: \(datos_enviados)")
                    
                    
                    if let array = try JSONSerialization.jsonObject(with: datos_recibidos!) as?
                        NSArray{comlectionHandler(array)}
                    
                }catch let parseError{print("Eror servidor PHP \(String(describing: String(data: datos_recibidos!,encoding: .utf8))) \(parseError)")
                    comlectionHandler(nil)
                }
            }
        }
        
        task.resume()
        
        
    }
}

