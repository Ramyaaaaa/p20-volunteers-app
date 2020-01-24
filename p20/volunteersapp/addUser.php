<?php

error_reporting(0);

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
        if(! is_array($input)) {

            $err = array( 
                "status"=>"400", 
                "message"=>"Data is not in JSON format"
                ); 
            
            $conn->close();
            exit(json_encode($err));
        }
        else if($input["id"] == 918273){

            $user = $input["user"];
            if (filter_var($user, FILTER_VALIDATE_EMAIL)) {
                $isEmail = true;
            }
            
            $barcode = $input["barcode"];
            /** Uncomment below lines for including functionality for not registered users */
            //$name = $input["name"];
            //$college = $input["college"];
            //$number = $input["number"];
            //$year = $input["year"];
            //$isRegistered = $input["isRegistered"];
            //$sql = "INSERT INTO userDetails (name,collegeName,phoneNumber,year,qrcode) values(?,?,?,?,?);";
            /** Uncomment above lines for including functionality for not registered users */


            if($isEmail == true)
                $sql = "UPDATE userDetails SET ticket = 1 , qrcode = ? where email = ?";
            else 
                $sql = "UPDATE userDetails SET ticket = 1 , qrcode = ? where id = ?";

            $stmt = $conn->prepare($sql);
            if(!$stmt)  {
                        
                $err = array( 
                    "status"=>"404", 
                    "message"=> $conn->error
                    ); 
                    $conn->close();
                    exit(json_encode($err)); 
            }
            $stmt->bind_param("ss",$barcode,$user);
            if(!$stmt->execute()) 
            {
                $err = array( 
                    "status"=>"404", 
                    "message"=> $stmt->error
                    );
                
                $conn->close();
                exit(json_encode($err));
            
            }
            
            $stmt->free_result();

        }
        else {
            $err = array( 
                "status"=>"400", 
                "message"=>"Wrong ID! Unauthorized access!!"); 
            
            
            $conn->close();
            exit(json_encode($err));
        
        }
        
        $res = array( 
            "status"=>"200", 
            "message"=>"Registration successful!"); 
        
            
        $conn->close();
        exit(json_encode($res));
        
          
    }
    else 
    {
        $err = array( 
            "status"=>"400", 
            "message"=>"Not a POST Method"); 
        
            
        $conn->close();
        exit(json_encode($err));

    }

}

catch(Exception $e)
{
    $err = array( 
        "status"=>"400", 
        "message"=> $e->getMessage()); 
    
    echo json_encode($err); 
}

?>
  




