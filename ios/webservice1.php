<?php
//Display errores muestra las alertas en caso de variables vacias
error_reporting(E_ALL);
ini_set('display_errors', 1);


//Array principal
$arrayFinal = array();
//Sub array, puede ser 1,2,3 o N cantidad de sub array que necesitemos
$subArray = array();


//Modo debug nos permite inyectar variables desde el navegador con elmetodo GET y verificar el array JSON que obtendremos de respuesta
if (isset($_GET['debug'])) {
    $id_usuario = $GET["id_usuario"];
} else {
    //Las sigueintes lineas convierten un array JSON a un array php
    $handle = fopen('php://input', 'r');
    $jsonInput = fgets($handle);
    $post = json_decode($jsonInput, true);

    //parameros que recibimos de nuestra aplicacion
    $id_usuario = $post["id_usuario"];
    $key = $post["key"];
    $fecha = $post["fecha"];
    $nombre = $post["nombre"];

    if ($key != "123456abcde" || $id_usuario == "" || !ctype_digit($id_usuario)) {
        $subArray['error'] = 3;
        $subArray['error_mensaje'] = "No tienes los permisos necesarios";
        array_push($arrayFinal, $subArray); //empujamos el subArray ($subArray) al arrray final ($ArrayFinal)
        echo json_encode($arrayFinal);
        exit;
    }
}

//Conexión a la base de datos con los parametros
$connection = mysqli_connect("localhost", "root", "root", "pruebaios");

//Consulta a la base de datos para extraer la informacion de un usuario en especifico por el id
$qu = mysqli_query($connection, "SELECT id,nombre,apellido,correo,fecha_alta FROM usuarios WHERE id= '$id_usuario' ") or
    die(mysqli_error($connection));


//Recorremos los resultados obtenidos de la consulta en la linea 17 y los vamos empujando al sub array --> subArray
if (mysqli_num_rows($qu) >= 1) { //Si se encontraron resultados
    while ($r = mysqli_fetch_array($qu)) {
        $subArray['error'] = 1; //evalua la respuesta
        $subArray['error_mensaje'] = "todo correcto";
        $subArray['id'] = $r['id'];
        $subArray['nombre'] = $r['nombre'];
        $subArray['apellido'] = $r['apellido'];
        $subArray['correo'] = $r['correo'];
        $subArray['fecha_alta'] = $r['fecha_alta'];
        //empujamos el subarray ($subArray) al array final
        array_push($arrayFinal, $subArray);
    }
} else { //no se encontro ningun resultado, mandamos mensaje de error para que sea evaluado por la app
    $subArray['error'] = 2;
    $subArray['error_mensaje'] = "No se encontraron resultados";
    array_push($arrayFinal, $subArray); //empujamos el subarray ($subArray) al array final
}

if (isset($_GET["debug"])) {
    echo "<pre>";
    print_r($arrayFinal);
    echo "<pre>";
} else {
    echo json_encode($arrayFinal);
}
