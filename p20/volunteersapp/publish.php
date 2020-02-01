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



     $a=array();
      $sql2 = "select * from ospc  order by marks desc,team_id";
                            $stmt2 = $conn->prepare($sql2);
                            if(!$stmt2)  {
                                
                                echo 'Data base error';
                            
                            }
                            else 
                            {
                              
                                $stmt2->execute();
                                
                                $stmt2->bind_result($barcode,$team,$mark,$name, $phone);
                                $prev='';
                                while( $stmt2->fetch()) {
                                              if($prev!=$team)
                                              {
                                                 $a[$team]=array(
                                                     "user"=>array(
                                                         "qrcode"=>$barcode,
                                                         "name"=>$name,
                                                         "phone"=>$phone
                                                     ),
                                                     "mark"=>$mark,
                                                     "selected"=>0,
                                                     "size"=>1
                                                 );
                                                 //array_push($a[$team],"sizet"=>2);
                                                 $prev=$team;
                                              }
                                             else{
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
                                         echo (json_encode($a));
                                         $fp = fopen('results.json', 'w');
                                        fwrite($fp, json_encode($a));
                                            fclose($fp);



                            }
                            $stmt2->free_result();
           
    

   echo 'kk;';
                         
                      

$conn->close();


?>
  




