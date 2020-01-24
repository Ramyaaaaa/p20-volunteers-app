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

    $has_err = 0;
    $user = file_get_contents('php://input');
    // echo $userID;
    // $teamID = $input["teamID"];
    // $event = $input["event"];
    // $marks = $input["marks"];
    if (filter_var($user, FILTER_VALIDATE_EMAIL)) {
        $isEmail = true;
    }
    if($isEmail == true)
        $sql = "SELECT name,collegeName,phoneNumber,year from userDetails where email = ?";
    else 
        $sql = "SELECT name,collegeName,phoneNumber,year from userDetails where id = ?";
    
    $stmt = $conn->prepare($sql);
    if(!$stmt)  {
                
        $err = array( 
            "status"=>"404", 
            "message"=> $conn->error
            ); 
            $has_err = 1;
            echo json_encode($err); 
    }
    else 
    {
        $stmt->bind_param("s",$user);
        if(!$stmt->execute()) 
        {
            $err = array( 
                "status"=>"404", 
                "message"=> $stmt->error
                );

            $has_err = 1;
            exit(json_encode($err));
        
        }

        $stmt->bind_result($name,$college,$phone,$year);
        $stmt->store_result();
        if ($stmt->num_rows > 0) {
            while($stmt->fetch()) {
                $res = array( 
                    "status"=>"200", 
                    "name" => $name,
                    "phone" => $phone,
                    "year" => $year,
                    "college"=> $college 
                    ); 
                
                
            }
                
        }   
        else {
            $err = array( 
                "status"=>"400", 
                "message"=>"No data for given user id / email"
                    ); 
            $has_err = 1;
            echo(json_encode($err));
            
        
        }

    }

    
    if($has_err == 0)   {
            echo json_encode($res); ;
    
    }   
}
else 
{
    $err = array( 
        "status"=>"400", 
        "message"=>"Not a POST Method"); 
    
    echo json_encode($err); ;

}
$stmt->free_result();
            
  
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
  




