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
        
        // var_dump(http_response_code(400));

        echo json_encode($err); ;
    }
    else if($input["id"] == 314253){

        $barcodes = $input["barcodes"];
        $event = $input["event"];
        $teamID = $input["teamID"];
        $barcodeArray = explode('&', $barcodes);
        array_pop($barcodeArray);

        if(sizeof($barcodeArray) == 0) {
            $err = array("status"=>"400", 
            "message"=> "No bar codes given by user");

            // var_dump(http_response_code(400));

            exit( json_encode($err));
        }
        // $teamID = "";
        // foreach($barcodeArray as $barcode)  {
        //     $teamID .= $barcode;
        // }
       // echo "team id " .$teamID;


        foreach($barcodeArray as $barcode)  {


            if($barcode != null && $barcode != ""   )   {

                $sql = "SELECT name from ". $event. " where barcode = ?";
                $stmt = $conn->prepare($sql);
                if($stmt)  {
                    $stmt->bind_param("s",$barcode);
                    $stmt->execute();
                    $stmt->bind_result($name);
                    $stmt->store_result();
            
                    if ($stmt->num_rows > 0) {
                        $e = "User with barcode ". $barcode ." already participated";
                        $err = array( 
                            "status"=>"404", 
                            "message"=> $e
                            ); 
                        
                        $has_err = 1;
                        
                $stmt->free_result();
                        
                        exit(json_encode($err));
                    }
                    
                }
                
                $stmt->free_result();
            }
        }
        

        foreach($barcodeArray as $barcode)  {

            // echo "barcode". $barcode;
            $sql = "SELECT name,phoneNumber FROM userDetails where qrcode = ? AND ticket >= 1";
            $stmt = $conn->prepare($sql);
            if(!$stmt)  {
                        
                $err = array( 
                    "status"=>"404", 
                    "message"=> $conn->error
                    ); 
                
                
                if($barcode != "" && $barcode != null)  {
                    $has_err = 1;
                    // var_dump(http_response_code(404));

                    echo json_encode($err); 
                }
            }
            else 
            {
                $stmt->bind_param("s",$barcode);
                $stmt->execute();
                $stmt->bind_result($name,$phoneNo);
                $stmt->store_result();
        
                if ($stmt->num_rows > 0) {
                    while($stmt->fetch()) {
                        if ($stmt->num_rows > 0) {
                        
                            $sql2 = "INSERT into " . $event. " (name,phoneNumber,barcode,team_id) VALUES (?,?,?,?);";
                            $stmt2 = $conn->prepare($sql2);
                            if(!$stmt2)  {
                                
                                $has_err = 1;
                                $err = array( 
                                    "status"=>"404", 
                                    "message"=>$conn->error); 
                                // var_dump(http_response_code(404));

                                echo json_encode($err); ;
                            
                            }
                            else 
                            {
                                $stmt2->bind_param("ssss",$name,$phoneNo,$barcode,$teamID);
                                $stmt2->execute();
                            }
                            $stmt2->free_result();
           
                        }
                            

                    }
            
                } 
                else {
                    
                    $has_err = 1;
                    $err = array( 
                        "status"=>"400", 
                        "message"=>"User with barcode ".$barcode. " did not complete payment!"); 
                    // var_dump(http_response_code(400));

                    exit(json_encode($err));
                }
            }
            $stmt->free_result();
           
        
            
        }

    

    }
    else {
        $has_err = 1;
        $err = array( 
            "status"=>"400", 
            "message"=>"Wrong ID! Unauthorized access!!"); 
        
        // var_dump(http_response_code(400));

        echo json_encode($err); ;
    
    }
    
    if($has_err == 0)   {
        $res = array( 
            "status"=>"200", 
            "team_id"=>$teamID); 
        //var_dump(http_response_code(200));

        echo json_encode($res); ;
    
    }   
}
else 
{
    $err = array( 
        "status"=>"400", 
        "message"=>"Not a POST Method"); 
    // var_dump(http_response_code(400));

    echo json_encode($err); ;

}
$conn->close();


?>
  




