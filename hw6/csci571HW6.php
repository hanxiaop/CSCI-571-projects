<?php
session_start();
?>



<?php
function checkInp($varr) {
    $varr = trim($varr);
    $varr = stripslashes($varr);
    $varr = htmlspecialchars($varr);
    return $varr;
}

if(isset($_POST['submit'])) {
    $keyword = checkInp($_POST["keyword"]);
    $category = checkInp($_POST["category"]);

    if (empty($_POST["distance"])) {
        $distance = "10";
    } else {
        $distance = checkInp($_POST["distance"]);
    }
    if (isset($_POST['locationText'])) {
        $locationTyped = checkInp($_POST["locationText"]);
        $locationURL = str_replace(' ', '+', $locationTyped);
        $fullURL = "https://maps.googleapis.com/maps/api/geocode/json?address=" . $locationURL
            . "&key=AIzaSyCAyFDwK7qI-4Q1yAP93AWwik3oAWGs0cA";
        $jsonGLoca = file_get_contents($fullURL);
        $jsonGLoca = json_decode($jsonGLoca);
        $latObt = $jsonGLoca->results[0]->geometry->location->lat;
        $lngObt = $jsonGLoca->results[0]->geometry->location->lng;
        $locationTypedR = array($latObt, $lngObt);
        $checkR = "a";
        $lccc = $_POST['locationText'];

    } else {
        $locationTyped = $_POST["location"];
        $locationTypedR = explode(",", $locationTyped); //array
        $checkR="b";
        $lccc = "11";
    }
    include("geoHash.php");
    $hash = encode($locationTypedR[0], $locationTypedR[1]);
    $_SESSION['originalLan'] = $locationTypedR[0];
    $_SESSION['originalLonti'] = $locationTypedR[1];



    $keywordURL = str_replace(' ', '+', $keyword);
    if ($category == "Music") {
        $segmentID = "&segmentId=KZFzniwnSyZfZ7v7nJ";
    } else if ($category == "Sports") {
        $segmentID = "&segmentId=KZFzniwnSyZfZ7v7nE";
    } else if ($category == "Arts & Theatre") {
        $segmentID = "&segmentId=KZFzniwnSyZfZ7v7na";
    } else if ($category == "Film") {
        $segmentID = "&segmentId=KZFzniwnSyZfZ7v7nn";
    } else if ($category == "Miscellaneous") {
        $segmentID = "&segmentId=KZFzniwnSyZfZ7v7n1";
    } else {
        $segmentID = "";
    }
    $tickMasURL = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=AzNforc4sWUIV3ilcFnVn7GIQpkxfhhh&keyword=" . $keywordURL
        . $segmentID . "&radius=" . $distance . "&unit=miles&geoPoint=" . $hash;
    $ticketMasterJson = file_get_contents($tickMasURL);
    $resultShwon = json_decode($ticketMasterJson);
    $finalJSON = json_encode($resultShwon);


}

?>

<?php
if(isset($_GET['eventID'])){
    $secondReq = checkInp($_GET['eventIDvalue']);
    $newAPIreq = "https://app.ticketmaster.com/discovery/v2/events/"
        .$secondReq."?apikey=AzNforc4sWUIV3ilcFnVn7GIQpkxfhhh&";
    $eventJSON = file_get_contents($newAPIreq);
    $eventJSON = json_decode($eventJSON);
    $oldPOsitionlan = $_SESSION['originalLan'];
    $oldPOsitionlon = $_SESSION['originalLonti'];

    $veneURLword = $eventJSON->_embedded->venues[0]->name;
    $newWordURL = str_replace(' ', '%20', $veneURLword);
    $urlVene = 'https://app.ticketmaster.com/discovery/v2/venues?apikey=AzNforc4sWUIV3ilcFnVn7GIQpkxfhhh&keyword='
        .$newWordURL;
    $veNeJson = file_get_contents($urlVene);
    $veNeJson = json_decode($veNeJson);

    $seoncdJSON = json_encode($eventJSON);


    $codedVenue = json_encode($veNeJson);
    $langitudeO = $veNeJson->_embedded->venues[0]->location->latitude;
    $longitudeO = $veNeJson->_embedded->venues[0]->location->longitude;


}


?>

<!DOCTYPE html>
<html>

<head>
    <style>
        body {
            width: 100%;
            margin: auto;
        }

        #outside {
            text-align: center;
            display: inline-block;

        }

        #eventSearch {
            background-color: rgb(230, 230, 230);
            width: 500px;
            height: 200px;

            border: 2px solid gray;
            text-align: left;


            position: absolute;
            left: 28%;
            top: 10%;

        }

        h1 {
            border-bottom: 1px black solid;
            text-align: center;
        }

        #radioStyle {
            margin: 0px 250px 0px;
        }

        input[type=submit]:disabled {
            color: #666666;
        }

        #displayResult {
            font-size: 12pt;

            width: auto;
            position: absolute;
            left:15%;
            top: 37%;
            text-align: left;
        }
        #displayResult222 {
            width: auto;
            text-align: center;



        }
        #venueINFO{
            width: 1000px;
            text-align: center;



        }
        #venueINFO th {
            text-align: right;

        }
        #venueINFO td{
            text-align: center;
        }
        #venueINFO button{
            margin: auto;
            color: gray;

        }
        #photoINFO button{
            margin: auto;
            color: gray;
        }

        #leftSide{
            text-align: left;
            display: inline-block;
            position: relative;


        }
        #RightSeatMap{
            text-align: right;
            display: inline-block;
            position: relative;
            left: 100px;
        }
        a:hover{
            color: gray;
            text-decoration: none;
        }
        a{
            text-decoration: none;
            color: black;
        }


        arrow{
            border: solid #a7a7a7;
            border-width: 0 8px 8px 0;
            display: inline-block;
            padding: 10px;

        }
        .butDown{
            transform: rotate(45deg);
            -webkit-transform: rotate(45deg);
        }
        .butUp{
            transform: rotate(-135deg);
            -webkit-transform: rotate(-135deg);
        }
        .down input[type=submit]:hover, .down input[type=submit]{
            border: none;
            padding: 0;
            background: none;
            color: gray;
        }
        #googleMap{
            height: 400px;
            width: 600px;
            position: relative;

        }
        #mapBigBlock{
            position: absolute;
            z-index: 5;
            left: 82%;
        }

        button {
            border: none;
            font-size: 12pt;
            font-family: Times;
            background-color: white;

        }
        #displayResult input[type="submit"]{
            font-size: 12pt;
            border: none;
            font-family: Times;
        }
        button:hover {
            font-size: 12pt;
            border: none;
            color: gray;
            font-family: Times;

        }
        #displayResult input[type="submit"]:hover{
            font-size: 12pt;
            border: none;
            color: gray;
            font-family: Times;
        }
        table, th, td {
            border: 1px solid gray;
            height: 10px;
        }
        table {
            border-collapse: collapse;
            width: 1000px;
        }
        .topTitle{
            text-align: center;
        }
        .tDate{
            text-align: center;
        }
        .mapCont{
            text-align: right;




        }
        #displayResult222#googleMap{


        }
        #outt{
            float: right;
            width: 700px;

        }
        .buttons{
            text-align: right;
            width: 100px;
            float: left;
            top: 60px;
            position: relative;
            left: : 60px;
        }
        .buuttonClass{
            width: 150px;
            float: left;
            top: 150px;

            position: relative;

            left: : 60px;
            z-index: 10;
        }

        .buuttonClass button{
            width: 150px;
            height: 50px;
            background-color: lightgray;
        }
        .buttons button{
            background-color: lightgray;


        }
        #noData{
            width: 800px;

            background-color: lightgray;
            border: 1px solid gray;
            color: black;
            position: absolute;
            top: 100px;
            left: 00px;
            text-align: center;

        }
        #photoEvne img{
            max-width: 100%;
            height: auto;

        }
        #photoEvne table{
            border: 1px;
            width: 1000px;
            text-align: center;
        }
        #photoEvne{
            border: 1px solid gray;

        }


    </style>
</head>

<body>
<div id="eventSearch">
    <h1><I>Events Search</I></h1>
    <form id = "searchForm" method="POST" action="">
        <label for="keyword">Keyword</label>
        <input id="keyword" type="text" name="keyword" required="required" value="<?php echo isset($_POST['keyword'])?$keyword:'' ?>"><br>

        <label for="category" >Category</label>
        <select id="category" name="category">
            <option value="Default" <?php if (isset($category) && $category=="Default") echo "selected";?>>Default</option>
            <option value="Music" <?php if (isset($category) && $category=="Music") echo "selected";?>>Music</option>
            <option value="Sports" <?php if (isset($category) && $category=="Sports") echo "selected";?>>Sports</option>
            <option value="Arts & Theatre" <?php if (isset($category) && $category=="Arts & Theatre") echo "selected";?>>Arts & Theatre</option>
            <option value="Film" <?php if (isset($category) && $category=="Film") echo "selected";?>>Film</option>
            <option value="Miscellaneous" <?php if (isset($category) && $category=="Miscellaneous") echo "selected";?>>Miscellaneous</option>
        </select><br>

        <label for="distance">Distance(miles)</label>
        <input id="distance" name="distance" placeholder="10" type="text" value="<?php echo isset($_POST['distance'])?$distance:'' ?>">


        <input id="radioHere" type="radio" name="location" checked="checked">
        <label for="radioHere">Here</label><br>
        <span id="radioStyle">
        <input id="typeLocation" type="radio" name="location">
        <input id="locTyped" type="text" name="locationText" placeholder="location" required="required" disabled="disabled" />
        </span> <br>

        <input id="search" type="submit" name="submit" value="Search" disabled="disabled">
        <script type="text/javascript">

            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            } else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function() {
                if (this.readyState === 4 && this.status === 200) {
                    ipJSON = this.responseText;
                }
            };
            xmlhttp.open("GET", "http://ip-api.com/json", false); // "synchronous"
            xmlhttp.send();
            ipJSON = JSON.parse(ipJSON);
            if (ipJSON.hasOwnProperty("lat")) {
                document.getElementById('radioHere').value= [ipJSON.lat,ipJSON.lon];

                //document.getElementById('radioHere').value = [ipJSON.lat, ipJSON.lon];
                document.getElementById('search').disabled = false;
            }


        </script>

        <input id="clear" type="reset" value="Clear" >


    </form>
</div>


<div id="displayResult">


    <div id="displayResult222">

    </div>

</div>


<?php

echo <<<jascode
<script type="text/javascript">
var josn_js=$finalJSON;
var oldLan = $locationTypedR[0];
var oldlon = $locationTypedR[1];
var checkRadioBut= $checkR;
var Loc = $lccc;

</script>
jascode

?>
<script type="text/javascript">

    var clientJSON = josn_js;
    var ccccc = clientJSON._embedded.events;

    if (ccccc !== undefined && ccccc.length !== 0) {
        var eventRoot = clientJSON._embedded.events;
        var hTable = "";
        if (eventRoot.length === 0) {
            hTable = "<p>No Records has been found</p>";
        } else {
            // display results
            hTable += "<div id ='mapBigBlock' style='display: none'><div class='buuttonClass'><button onclick='Walk()'>Walk there</button>"
                + "<button onclick='Bike()'>Bike there</button><button onclick='Drive()'>Drive there</button></div><div id='googleMap' ></div></div>";
            hTable += "<table ><tbody><tr class='topTitle'><th>Date</th><th>Icon</th><th>Event</th><th>Genre</th><th>Venue</th></tr>";


            for (var i = 0; i < eventRoot.length; i++) {
                hTable += "<tr>";

                var date = eventRoot[i].dates.start;

                //display date
                if (date.localDate !== undefined) {
                    if (date.localTime !== undefined) {
                        hTable += "<td class='tDate'>" + date.localDate + "<br>" + date.localTime + "</td>";
                    } else {
                        hTable += "<td class='tDate'>" + date.localDate + "</td>";
                    }
                }else{
                    hTable+="<td>N / A</td>"
                }


                // display LOGO
                if (eventRoot[i].images !==undefined) {
                    var images = eventRoot[i].images;
                    var ratio = 100 * images[0].height / images[0].width;
                    var urlImage = images[0].url;
                    hTable += "<td><img src='" + urlImage + "' style='width: 100px;height: " + ratio + "'>";

                    hTable += "<td>" + "<form method='GET' action='' id='aFormm' ><input type='hidden' name='eventIDvalue' value='" + eventRoot[i].id
                        + "'><input type='hidden' name='eventID' value='idd' ><button id='submmit' >"+eventRoot[i].name+"</button></form></td>";
                    //<input type='submit' name='eventID' id='listent' value=&quot;" + eventRoot[i].name + "&quot;>
                }else{
                    hTable+="<td>N / A</td>"
                }

                if (eventRoot[i].classifications !== undefined) {
                    hTable += "<td>" + eventRoot[i].classifications[0].segment.name + "</td>";
                }else{
                    hTable+="<td>N / A</td>"
                }

                if (eventRoot[i]._embedded.venues[0].location !== undefined) {
                    eventPOsition = [eventRoot[i]._embedded.venues[0].location.latitude, eventRoot[i]._embedded.venues[0].location.longitude];
                    evtStringValue = eventPOsition[0].toString() + "," + eventPOsition[1].toString();
                    hTable += "<td><button onclick='geneMap(this)' value='" + evtStringValue + "'>" + eventRoot[i]._embedded.venues[0].name + "</button></td>";
                }else {
                    hTable+="<td>N / A</td>";
                }

                hTable += "</tr>";
            }


            hTable += "</tbody></table>";


            document.getElementById("displayResult").innerHTML = hTable;

            document.getElementById("submmit").addEventListener("click", function () {
                form.submit();
            });


            function initMap() {


                theLocationChange = new google.maps.LatLng(eventPOsition[0], eventPOsition[1]);


                map = new google.maps.Map(
                    document.getElementById("googleMap"), {zoom: 6, center: theLocationChange});

                marker = new google.maps.Marker({position: theLocationChange, map: map});

                dS = new google.maps.DirectionsService;
                dD = new google.maps.DirectionsRenderer;


            }

            function Walk() {
                marker.setMap(null);
                dD.setMap(map);
                dS.route({
                    origin: new google.maps.LatLng(oldLan, oldlon),
                    //destination: {lat:marker.getPosition().lat(),lng:marker.getPosition().lng()},
                    destination: new google.maps.LatLng(eventPOsition[0], eventPOsition[1]),
                    travelMode: "WALKING",
                }, function (response, status) {
                    if (status === 'OK') {
                        dD.setDirections(response);
                    }
                });
            }

            function Bike() {
                marker.setMap(null);
                dD.setMap(map);
                dS.route({
                    origin: new google.maps.LatLng(oldLan, oldlon),
                    //destination: {lat:marker.getPosition().lat(),lng:marker.getPosition().lng()},
                    destination: new google.maps.LatLng(eventPOsition[0], eventPOsition[1]),
                    travelMode: "BICYCLING",
                }, function (response, status) {
                    if (status === 'OK') {
                        dD.setDirections(response);
                    }
                });
            }

            function Drive() {
                marker.setMap(null);
                dD.setMap(map);
                dS.route({
                    origin: new google.maps.LatLng(oldLan, oldlon),
                    //destination: {lat:marker.getPosition().lat(),lng:marker.getPosition().lng()},
                    destination: new google.maps.LatLng(eventPOsition[0], eventPOsition[1]),
                    travelMode: "DRIVING",
                }, function (response, status) {
                    if (status === 'OK') {
                        dD.setDirections(response);
                    }
                });
            }

            function geneMap(evt) {
                dD.setMap(null);
                var theString = evt.value;
                var arr = theString.split(",");
                //alert(theString);
                map.setCenter(new google.maps.LatLng(arr[0], arr[1]));
                marker.setPosition(new google.maps.LatLng(arr[0], arr[1]));
                marker.setMap(map);
                eventPOsition = [arr[0], arr[1]];

                var theBlock = document.getElementById("mapBigBlock").style.display;
                if (theBlock === "none") {
                    document.getElementById("mapBigBlock").style.display = 'inline-block';
                } else {
                    document.getElementById("mapBigBlock").style.display = 'none';
                }

            }

        }
    }



</script>



<?php


echo <<<jascode2
<script type="text/javascript">
var seccc=$seoncdJSON;
var evtJSON=$codedVenue;
var oldPOsLan=$oldPOsitionlan;
var oldPOsLon=$oldPOsitionlon;
</script>
jascode2

?>


<script type="text/javascript">

   if(seccc !==null) {
       var secFile = seccc;
       var fTable = "";
       langitudeO = secFile._embedded.venues[0].location.latitude;
       longitudeO = secFile._embedded.venues[0].location.longitude;

       fTable += "<h2>" + secFile.name + "</h2>";
       fTable += "<div id='leftSide'>";

       if (secFile.dates !== undefined) {
           fTable += "<p class='eventTitle'><b>Date</b></p>";
           fTable += "<p class='eventContent'>" + secFile.dates.start.localDate
               + " " + secFile.dates.start.localTime + "</p>";

       }


       var artistTeam = secFile._embedded.attractions;
       if (artistTeam !== undefined && artistTeam.length === 2) {
           var name1 = artistTeam[0].name;
           var name2 = artistTeam[1].name;
           var url1 = artistTeam[0].url;
           var url2 = artistTeam[1].url;
           fTable += "<p class='eventTitle'><b>Artist/Team</b></p><p class='eventContent'>";
           if (url1 !== undefined && url2 !== undefined) {
               fTable += "<a href='" + url1 + "' target=\"_blank\">" + name1 + "</a>" + " | "
                   + "<a href='" + url2 + "' target=\"_blank\">" + name2 + "</a>";

           } else if (url1 !== undefined) {
               fTable += "<a href='" + url1 + "' target=\"_blank\">" + name1 + "</a>" + " | " + name2;

           } else if (url2 !== undefined) {
               fTable += name1 + " | " + "<a href='" + url2 + "' target=\"_blank\">" + name2 + "</a>";
           } else {
               fTable += name1 + " | " + name2;
           }

           fTable += "</p>";

       } else if (artistTeam !== undefined && artistTeam.length === 1) {
           var name3 = artistTeam[0].name;
           var url3 = artistTeam[0].url;
           if (url3 !== "") {
               fTable += "<p class='eventTitle'><b>Artist/Team</b></p><p class='eventContent'>";
               fTable += "<a href='" + url3 + "' target=\"_blank\">" + name3 + "</a>";
           } else {
               fTable += name3;
           }

       } else {

       }


       if (secFile._embedded.venues !== undefined && secFile._embedded.venues.length !== 0) {
           var veneINFO = secFile._embedded.venues;
           var nVeneInf = veneINFO[0];
           fTable += "<p class='eventTitle'><b>Venue</b></p><p class='eventContent'>"
               + nVeneInf.name + "</p>";

       }


       if (secFile.classifications !== undefined) {
           var AGenRES = secFile.classifications[0];
           var GenRES = AGenRES;
           fTable += "<p class='eventTitle'><b>Genres</b></p><p class='eventContent'>";
           if (GenRES.segment !== undefined && GenRES.segment.name !== "Undefined") {
               fTable += GenRES.segment.name + " | ";
           }
           if (GenRES.genre !== undefined && GenRES.genre.name !== "Undefined") {
               fTable += GenRES.genre.name + " | ";
           }
           if (GenRES.subGenre !== undefined && GenRES.subGenre.name !== "Undefined") {
               fTable += GenRES.subGenre.name + " | ";
           }
           if (GenRES.type !== undefined && GenRES.type.name !== "Undefined") {
               fTable += GenRES.type.name + " | ";
           }
           if (GenRES.subType !== undefined && GenRES.subType.name !== "Undefined") {
               fTable += GenRES.subType.name + " | ";
           }

           fTable = fTable.substring(0, fTable.length - 2);

       }

       var priceRange = secFile.priceRanges;
       if (priceRange !== undefined) {
           fTable += "<p class='eventTitle'><b>Price Ranges</b></p><p class='eventContent'></p>";
           var minRange = priceRange[0].min;
           var maxRange = priceRange[0].max;
           if (minRange !== 0) {
               if (maxRange !== 0) {
                   fTable += minRange + " - " + maxRange + " USD</p>";
               } else {
                   fTable += "Minimum price is " + minRange + " USD</p>";
               }
           } else if (isset($maxRange)) {
               fTable += "Maximum price is " + maxRange + " USD</p>";
           }

       }


       if (secFile.dates.status.code !== undefined) {
           var status = secFile.dates.status.code;
           fTable += "<p class='eventTitle'><b>Ticket Status</b></p><p class='eventContent'>"
               + status + "</p>";
       }

       if (secFile.url !== undefined) {
           var urlTick = secFile.url;
           fTable += "<p class='eventTitle'><b>Buy Ticket At:</b></p><p class='eventContent'>"
               + "<a href='" + urlTick + "' target='_blank'>Ticketmaster</a></p>";
       }
       fTable += "</div>";


       if (secFile.seatmap !== undefined) {
           var seatMap = secFile.seatmap.staticUrl;
           fTable += "<div id='RightSeatMap'><img src='" + seatMap + "'></div>";
       }


       fTable += "<div id='venueINFO'>"; //1


       function veneCheck(variab) {
           if (variab !== "") {
               return variab;
           } else {
               return "N/A";
           }
       }

       ssssFile = evtJSON;//evtJSON;

       if (ssssFile === undefined || ssssFile._embedded.venues === undefined) {
           fTable += "<div class='down'>"
               + "<button id='eventVenueDown' onclick='setmapFunc2()' style='display:block'>"
               + "click to view venue info<br><arrow class='butDown'></arrow>" + "</button><br>"
               + "<button id='eventVenueUp' style='display:none'>"
               + "click to hide venue info<br><arrow class='butUp'></arrow>" + "</button><br></div>";

           fTable += "<div id='tableEvne' style='display: none; border: 1px solid lightgray' ><b>No Venue Info Found</b></div></div>";
           fTable += "<div id='photoINFO'>";
           fTable += "<div class='down' >"
               + "<button  id='photoVenueDown' style='display:block'>"
               + "click to view venue photos<br><arrow class='butDown'></arrow>" + "</button><br>"
               + "<button  id='photoVenueUp' style='display:none'>"
               + "click to hide venue photos<br><arrow class='butUp'></arrow>" + "</button><br></div>";
           fTable += "<div id='photoEvne'  style='display: none'><b>No Venue Photos Found</b></div>";
           fTable += "</div>";
           document.getElementById("displayResult222").innerHTML = fTable;


       } else {
           fTable += "<div class='down'>"
               + "<button id='eventVenueDown' onclick='setmapFunc(lanDeg,lonDeg)' style='display:block'>"
               + "click to view venue info<br><arrow class='butDown'></arrow>" + "</button><br>"
               + "<button id='eventVenueUp' style='display:none'>"
               + "click to hide venue info<br><arrow class='butUp'></arrow>" + "</button><br></div>";


           vvvFFFFF = ssssFile._embedded.venues;


           if (vvvFFFFF[0].images !== undefined) {

               widthV = vvvFFFFF[0].images[0].width;
               heightV = vvvFFFFF[0].images[0].height;
           }


           lanDeg = vvvFFFFF[0].location.latitude;
           lonDeg = vvvFFFFF[0].location.longitude;
           oldPosLanG = oldPOsLan;
           oldPosLonG = oldPOsLon;


           if (ssssFile !== "") {
               var veNFile = ssssFile._embedded.venues;


               fTable += "<div id='tableEvne' style='display: none'>";
               fTable += "<table border='1'><tbody>";
               fTable += "<tr><th>Name</th><td>" + veNFile[0].name + "</td></tr>";
               fTable += "<tr><th>Map</th><td class='mapCont'><div class='buttons'><button onclick='Walk()'>Walk there</button>"
                   + "<button onclick='Bike()'>Bike there</button><button onclick='Drive()'>Drive there</button></div><div id='outt'> <div id='googleMap'></div></div></td></tr>";
               //   +"<button id ='b2' onclick='Dirct(this.id,oldPosLan,oldPosLon)' value='BICYCLING'>Bike there</button><button id ='b3' onclick='Dirct(this.id,oldPosLan,oldPosLon)' value='DRIVING'>Drive there</button></div><div id='googleMap'></div></td></tr>";


               //saveLoCation = veneCheck(veNFile[1]).city.name+" ," +veneCheck(veNFile[1].state.stateCode);
               fTable += "<tr><th>Address</th><td>" + veneCheck(veNFile[0].address.line1) + "</td></tr>";
               fTable += "<tr><th>city</th><td>" + veneCheck(veNFile[0]).city.name + " ,"
                   + veneCheck(veNFile[0].state.stateCode) + "</td></tr>";
               fTable += "<tr><th>Postal Code</th><td>" + veneCheck(veNFile[0].postalCode) + "</td></tr>";
               fTable += "<tr><th>Upcoming Events</th><td>" + "<a href='" + veNFile[0].url + "' target=\"_blank\">" + veNFile[0].name
                   + " Tickets</a></td></tr>";
               fTable += "</tbody></table>";

               fTable += "</div>";
           }


           fTable += "</div>";


           fTable += "<div id='photoINFO'>";

           fTable += "<div class='down' >"
               + "<button  id='photoVenueDown' style='display:block'>"
               + "click to view venue photos<br><arrow class='butDown'></arrow>" + "</button><br>"
               + "<button  id='photoVenueUp' style='display:none'>"
               + "click to hide venue photos<br><arrow class='butUp'></arrow>" + "</button><br></div>";


           if (vvvFFFFF[0].images !== undefined) {
               fTable += "<div id='photoEvne' style='display: none' ><table><tbody>";
               for (var i = 0; i < vvvFFFFF[0].images.length; i++) {

                   fTable += "<tr><td><img src='" + veneCheck(vvvFFFFF[0].images[i].url)
                       + "' ></td></tr>";
               }
               fTable += "</tbody></table></div>"

           } else {
               fTable += "<div id='photoEvne'  style='display: none'><b>No Venue Photos Found</b></div>";

           }


           fTable += "</div>";


           document.getElementById("displayResult222").innerHTML = fTable;


           function initMap() {


               theLocationChange = new google.maps.LatLng(langitudeO, longitudeO);


               map = new google.maps.Map(
                   document.getElementById("googleMap"), {zoom: 6, center: theLocationChange});

               marker = new google.maps.Marker({position: theLocationChange, map: map});

               dS = new google.maps.DirectionsService;
               dD = new google.maps.DirectionsRenderer;


           }

           function Walk() {
               marker.setMap(null);
               dD.setMap(map);
               dS.route({
                   origin: new google.maps.LatLng(oldPosLanG, oldPosLonG),
                   //destination: {lat:marker.getPosition().lat(),lng:marker.getPosition().lng()},
                   destination: new google.maps.LatLng(langitudeO, longitudeO),
                   travelMode: "WALKING",
               }, function (response, status) {
                   if (status === 'OK') {
                       dD.setDirections(response);
                   }
               });
           }

           function Bike() {
               marker.setMap(null);
               dD.setMap(map);
               dS.route({
                   origin: new google.maps.LatLng(oldPosLanG, oldPosLonG),
                   //destination: {lat:marker.getPosition().lat(),lng:marker.getPosition().lng()},
                   destination: new google.maps.LatLng(langitudeO, longitudeO),
                   travelMode: "BICYCLING",
               }, function (response, status) {
                   if (status === 'OK') {
                       dD.setDirections(response);
                   }
               });
           }

           function Drive() {
               marker.setMap(null);
               dD.setMap(map);
               dS.route({
                   origin: new google.maps.LatLng(oldPosLanG, oldPosLonG),
                   //destination: {lat:marker.getPosition().lat(),lng:marker.getPosition().lng()},
                   destination: new google.maps.LatLng(langitudeO, longitudeO),
                   travelMode: "DRIVING",
               }, function (response, status) {
                   if (status === 'OK') {
                       dD.setDirections(response);
                   }
               });
           }

       }


   }


</script>

<?php
if (isset($_POST['submit'])&&!isset(json_decode($finalJSON)->_embedded->events))

    echo <<<jascode3
    
<script type="text/javascript">
    document.getElementById("displayResult222").innerHTML = "<div id='noData'></div>";
    document.getElementById("noData").innerHTML = "<b>No Records has been found</b>";
    

</script>
jascode3
?>




<script>


    document.getElementById("radioHere").addEventListener("change",function controlLocation(){
        var position = document.getElementById("radioHere");
        if (position.checked){
            document.getElementById("locTyped").disabled = true;
        }
    });
    document.getElementById("typeLocation").addEventListener("change",function controlLocation2(){
        var position = document.getElementById("typeLocation");
        if (position.checked){
            document.getElementById("locTyped").disabled = false;
        }
    });


    document.getElementById("searchForm").addEventListener("reset",function (){
        document.getElementById("searchForm").reset();
        document.getElementById("locTyped").disabled = true;
        document.getElementById("displayResult").innerHTML="";
        document.getElementById("displayResult222").innerHTML="";

        document.getElementById("noData").innerHTML="";
    });

    function setmapFunc(lantt,longgg){
        map.setCenter(new google.maps.LatLng(lantt, longgg));
        marker.setPosition(new google.maps.LatLng(lantt, longgg));
        document.getElementById("eventVenueDown").style.display="none";
        document.getElementById("eventVenueUp").style.display="block";
        document.getElementById("tableEvne").style.display="block";


    }

    function setmapFunc2(){
        document.getElementById("eventVenueDown").style.display="none";
        document.getElementById("eventVenueUp").style.display="block";
        document.getElementById("tableEvne").style.display="block";
    }

    document.getElementById("eventVenueUp").addEventListener("click",function () {
        document.getElementById("eventVenueUp").style.display="none";
        document.getElementById("eventVenueDown").style.display="block";
        document.getElementById("tableEvne").style.display="none";



    });
    document.getElementById("photoVenueDown").addEventListener("click",function () {
        document.getElementById("photoVenueDown").style.display="none";
        document.getElementById("photoVenueUp").style.display="block";
        document.getElementById("photoEvne").style.display="block";

       // document.getElementById("noPhoto").style.display = "block";
       // document.getElementsByClassName("up").style.display="block";


    });

    document.getElementById("photoVenueUp").addEventListener("click",function () {
        document.getElementById("photoVenueUp").style.display="none";
        document.getElementById("photoVenueDown").style.display="block";
        document.getElementById("photoEvne").style.display="none";
       // document.getElementsByClassName("up").style.display="none";

    });






</script>

<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCAyFDwK7qI-4Q1yAP93AWwik3oAWGs0cA&callback=initMap">
</script>




</body>
</html>
