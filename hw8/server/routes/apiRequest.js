const express = require('express');
const router = express.Router();

const geohash = require('ngeohash');
const axios = require('axios');
const SpotifyWebApi = require('spotify-web-api-node');
const tickMastAPI = 'https://app.ticketmaster.com/discovery/v2/events.json?apikey=aaa';




router.get('/', (req, res) => {

    if (req.query.keyword && req.query.distance){

      var reqPart;
      var category;
      geoLatLng = '';
      if (req.query.category === 'Music'){

        category = '&segmentId=KZFzniwnSyZfZ7v7nJ';
      } else if (req.query.category === 'Sports') {
        category = '&segmentId=KZFzniwnSyZfZ7v7nE';
      } else if (req.query.category === 'ArtandTheatre') {
        category = '&segmentId=KZFzniwnSyZfZ7v7na';
      } else if (req.query.category === 'Film') {
        category = '&segmentId=KZFzniwnSyZfZ7v7nn';
      } else if (req.query.category === 'Miscellaneous') {
        category = '&segmentId=KZFzniwnSyZfZ7v7n1';
      } else {
        category = '';
      }




      if (req.query.herelocation) {

        reqPart = '&keyword=' + req.query.keyword.replace(/\s+/g, '+') + '&radius=' + req.query.distance + '&unit=' + req.query.unit
          + '&geoPoint=' + geohash.encode(req.query.herelocation.split(" ")[0], req.query.herelocation.split(" ")[1])+category;

        console.log(req.query.keyword);
        console.log(req.query.distance);
        console.log(req.query.unit);
        console.log(req.query.herelocation);



        axios.get(tickMastAPI+reqPart).then(resopnse=>{
          //res.status(200).json(resopnse.data);
          res.status(200).json(resopnse.data);
          //console.log(tickMastAPI+reqPart);
          //console.log(resopnse.data);
        })
          .catch(error =>{
            res.status(500).send(error);
            console.log(error);
          })
      } else {
        var googleGeoUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address='
          + req.query.locationtype.replace(' ', '+') + '&key=aaa';
        // console.log(googleGeoUrl);

        console.log(req.query.locationtype);
        axios.get(googleGeoUrl).then( theResp => {
            // lngLon = [theResp.data.results[0].geometry.location.lat,theResp.data.results[0].geometry.location.lng];
            // console.log(theResp.data.results[0].geometry.location.lat);
            theUrll = reqPart = '&keyword=' + req.query.keyword.replace(' ', '+') + '&radius=' + req.query.distance + '&unit=' + req.query.unit
              + '&geoPoint=' + geohash.encode(theResp.data.results[0].geometry.location.lat, theResp.data.results[0].geometry.location.lng)+category;
            // console.log(tickMastAPI+theUrll);
            axios.get(tickMastAPI+theUrll).then(responses => {
              res.status(200).json(responses.data);
             // console.log(responses.data);
            })

            //res.status(200).json(theResp.data);
          }
        );

      }
      // console.log(tickMastAPI+reqPart);
    } else if (req.query.keyword && req.query.searchType){
      // console.log(req.query.keyword.replace(/\s+/g, '+'));

      var uri ='https://www.googleapis.com/customsearch/v1?q=' + req.query.keyword.replace(/\s+/g, '+') + '&cx=aaijuikvey&imgSize=huge&imgType=news&num=8&searchType=' +
        req.query.searchType.replace(' ', '+') + '&key=aaa';
      console.log(uri);
      // console.log(uri);
      axios.get(uri).then( response => {
        res.status(200).json(response.data);
        //console.log(responses.data);
      })
        .catch(error => {
          console.log(error);
        })




    } else if (req.query.keyword) {
      var spotifyApi = new SpotifyWebApi({
        clientId: 'aaa',
        clientSecret: 'aaa',
        redirectUri: 'http://localhost:4800/callback'
      });


      spotifyApi.searchArtists(req.query.keyword)
        .then(function(data) {
          console.log(data.body);
        }, function(err) {
          if (err.statusCode === 401) {
            spotifyApi.clientCredentialsGrant().then(response => {
              var accessToken = response.body.access_token;
              spotifyApi.setAccessToken(accessToken);
              spotifyApi.searchArtists(req.query.keyword).then(
                function(data) {
                  res.status(200).json(data.body);
                 // console.log(data.body);
                },
                function(err) {
                  console.error(err);
                }
              );
            });
          }
        });
    } else if (req.query.venuekeyword) {
      let tickUri = 'https://app.ticketmaster.com/discovery/v2/venues?apikey=aaa&keyword='
        + req.query.venuekeyword;
     // console.log(tickUri);
      axios.get(tickUri).then(response =>{
        //console.log(response.data);
        res.status(200).json(response.data);
      })
        .catch(error => {
          console.log(error);
        })

    } else if (req.query.songkickReq) {
      var reqUrl = 'https://api.songkick.com/api/3.0/search/venues.json?query='
        + req.query.songkickReq.replace(' ', '+') + '&apikey=aaa';
      //console.log(reqUrl);
      axios.get(reqUrl).then(res => {
        if(res.data.resultsPage.status === 'ok') {
          var theUniqID = res.data.resultsPage.results.venue[0].id;
          var newUri = 'https://api.songkick.com/api/3.0/venues/' + theUniqID
            + '/calendar.json?&apikey=aaaa';
          return axios.get(newUri);
        }
      })
        .then(resbopse => {
          //console.log(resbopse.data);
          res.status(200).json(resbopse.data);
        })
    } else if (req.query.autoCompkeyword) {
      //console.log(111);
      var reqU = 'https://app.ticketmaster.com/discovery/v2/suggest?apikey=aaa='
        + req.query.autoCompkeyword.replace(' ', '+');
      //console.log(reqU);
      axios.get(reqU).then(respp => {
        res.status(200).json(respp.data);
        console.log(respp.data);
        //console.log(respp.data);
      }).catch(err => {

      })

    }




  }
);



module.exports = router;
