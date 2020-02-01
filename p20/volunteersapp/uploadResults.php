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
    $entityBody = file_get_contents('php://input');
    $input = json_decode($entityBody, TRUE); 
    if(! is_array($input)) {
        $has_err = 1;

        $err = array( 
            "status"=>"400", 
            "message"=>"Data is not in JSON format"
            ); 
        
        echo json_encode($err); ;
    }
    else if($input["id"] == 425364){

        $teamID = $input["teamID"];
        $event = $input["event"];
        $marks = $input["marks"];
            
            $sql = "SELECT name from ". $event. " where team_id = ?";
            $stmt = $conn->prepare($sql);
            if(!$stmt)  
            {
                $err = array( 
                "status"=>"404", 
                "message"=> $conn->error
                ); 
                $has_err = 1;
                echo json_encode($err); 
            }
            else 
            {
                $stmt->bind_param("s",$teamID);
                if(!$stmt->execute()) 
                {
                    $err = array( 
                        "status"=>"404", 
                        "message"=> $stmt->error
                        );

                    $has_err = 1;
                    exit(json_encode($err));
                
                }
                else {
                                
                    $stmt->bind_result($name);
                    $stmt->store_result();
                    if ($stmt->num_rows > 0) {
                        $sql = "UPDATE ". $event. " SET marks = ? where team_id = ?";
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
                            $stmt->bind_param("ss",$marks,$teamID);
                            if(!$stmt->execute()) 
                            {
                                $err = array( 
                                    "status"=>"404", 
                                    "message"=> $stmt->error
                                    );

                                $has_err = 1;
                                exit(json_encode($err));
                            
                            }
                            
                            $stmt->free_result();
                        }
                    }
                    else {
                        $err = array( 
                            "status"=>"404", 
                            "message"=> "No data for given team ID"
                            );

                        $has_err = 1;
                        exit(json_encode($err));
                    
                    }
                }
            }
         

    
                
             
            
    

    }
    else {
        $has_err = 1;
        $err = array( 
            "status"=>"400", 
            "message"=>"Wrong ID! Unauthorized access!!"); 
        
        echo json_encode($err); ;
    
    }
    
    if($has_err == 0)   {
        $res = array( 
            "status"=>"200", 
            "message"=>"Marks updated successfully"); 
        
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
  




