<?php

//error_reporting(0);

$servername = "mysql.csmit.org";
$username = "prayatna_user";
$password = "qd5egqd5";
$dbname = "prayatna_db";


// $servername = "localhost";
// $username = "root";
// $password = "";
// $dbname = "prayatna";
// Create connection
$conn = new mysqli($servername, $username, $password,$dbname) or die("Unable to connect");
//echo "connection success";


try {
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $entityBody = file_get_contents('php://input');

        $input = json_decode($entityBody, TRUE); 
        

        $has_err = 0;
        
        if(! is_array($input)) {
            $has_err = 1;

            $err = array( 
            "status"=>"400", 
            "message"=>"Data is not in JSON format"
            ); 
        
        // var_dump(http_response_code(400));

            echo json_encode($err); 
        }
    
        else if($input["id"] == 425364){

            echo "input id correct";
        }
     
    }
    else 
    {
        $err = array( 
            "status"=>"400", 
            "message"=>"Not a POST Method"); 
        
        echo json_encode($err); ;
    
    }
    
    $conn->close();
}
catch(Exception $e)
{
    $err = array( 
        "status"=>"400", 
        "message"=> $e->getMessage()); 
    
    echo json_encode($err); 

}




?>
  




