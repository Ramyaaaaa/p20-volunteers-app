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

            $res = json_decode(file_get_contents('results.json'),TRUE);
            // echo $res;
            if (is_array($res)) {

                if($input["view"] == 1)  {
                    exit(json_encode($res));
                }
                else {
                    $has_err = 1;

                    $err = array( 
                    "status"=>"200", 
                    "message"=>"Results are already published!"
                    ); 
                
                // var_dump(http_response_code(400));

                    exit(json_encode($err)); 
                
                }
            }

            $passMark = $input["passMark"];
            $event = $input["event"];
          
            $a=array();
            $sql = "select * from ". $event. " order by marks desc,team_id";
            $stmt = $conn->prepare($sql);
            if(!$stmt)  
            {
                $err = array( 
                "status"=>"404", 
                "message"=> $conn->error
                ); 
                $has_err = 1;
                exit(json_encode($err));
            }
            if(!$stmt->execute()) 
            {
                $err = array( 
                    "status"=>"404", 
                    "message"=> $stmt->error
                    );

                $has_err = 1;
                exit(json_encode($err));
            
            }
            $stmt->bind_result($barcode,$team,$mark,$name,$phone);
            $prev='';
            $stmt->store_result();
            if ($stmt->num_rows > 0) {
                while($stmt->fetch()) {
                    //if(!array_key_exists($team,$a))
                    if($prev!=$team)
                    {
                        $selected = ($mark >= $passMark) ? 1 : 0;

                        $a[$team]=array(
                            "user"=>array(array(
                                "qrcode"=>$barcode,
                                "name"=>$name,
                                "phone"=>$phone
                            )),
                            "mark"=>$mark,
                            "selected"=> $selected,
                            "size"=>1
                        );
                        //array_push($a[$team],"sizet"=>2);
                        $prev=$team;
                    }
                    else
                    {
                        $teamsize=$a[$team]["size"];
                        $newname='u'.($teamsize+1);
                    //   echo $teamsize;
                        $b=array(
                                "qrcode"=>$barcode,
                                "name"=>$name,
                                "phone"=>$phone
                        );
                        array_push($a[$team]["user"],$b);
                        $a[$team]["size"]+=1;
                    }

                }
                    //    print_r($a);
                //echo (json_encode($a));
                
                if($input["view"] == 1)  {
                    exit(json_encode($a));
                }
                else {
                    $fp = fopen($event'.json', 'w');
                    fwrite($fp, json_encode($a));
                    fclose($fp);
                    
                }
            }
                

            $stmt->free_result();                      
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
                "message"=>"Results have been published successfully"); 
            //var_dump(http_response_code(200));

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
  




