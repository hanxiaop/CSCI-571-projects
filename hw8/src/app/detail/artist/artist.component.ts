import { Component, OnInit } from '@angular/core';
import {ArtistModel} from './artist.model';
import {TransferDataService} from '../../services/transferData.service';
import {ObservabService} from '../../services/observab.service';

@Component({
  selector: 'app-artist',
  templateUrl: './artist.component.html',
  styleUrls: ['./artist.component.css']
})
export class ArtistComponent implements OnInit {
  artistModel = new Array();
  nameListAR: any;
  artistPhoto = new Array();

  constructor(private transferData: TransferDataService, private observBale: ObservabService) { }

  ngOnInit() {

    // this.transferData.listTableToArtisName.subscribe( res => {
    //   console.log(res);
    // });
    // this.transferData.listTableToArtisGoogle.subscribe( resp => {
    //   console.log(resp);
    // });
    // this.transferData.listTableToArtistSPO.subscribe( respo => {
    //   console.log(respo);
    // });
    this.observBale.currentDataartistName.subscribe( res => {
      this.nameListAR = res;
      console.log(this.nameListAR);
    });


    this.observBale.artistGdata.subscribe( res => {
      let temGoogle: any = res;
      console.log(temGoogle);
      if (temGoogle){
        for (let names of this.nameListAR) {
          let check = 0;
          let commonSarr = new Array();
          for (let results of temGoogle) {

            if (results.queries) {
              if (results.queries.request[0].searchTerms.toLowerCase() === names.toLowerCase()) {
                if (results.items) {
                  for (let item of results.items) {
                    let itemLink = item.link;
                    let itemHeight = item.image.height;
                    let itemWidth = item.image.width;
                    let ratio = parseFloat(itemHeight) / parseFloat(itemWidth);
                    let obj: any = {'linkimg': itemLink, 'ratio': ratio};
                    commonSarr.push({obj});
                  }
                }
                commonSarr.sort((a, b) => a.obj.ratio < b.obj.ratio ? 1 : -1);
                this.artistPhoto.push(commonSarr);
                check = 1;
              }
            }
          }
          if (check === 0) {
            this.artistPhoto.push(commonSarr);
          }
        }
      }
      console.log(this.artistPhoto);



    });
    this.observBale.artistSpotifyData.subscribe( res => {
      if (res) {
        let tempArtist: any = res;
        for (let name of this.nameListAR) {
          let check = 0 ;
          let tempArtModel = new ArtistModel('', '', '', '');
          for (let artis of tempArtist) {
            if (artis.hasOwnProperty('artists')) {
              if (artis.artists.items.length !== 0) {

                if (artis.artists.items[0].name.toLowerCase() === name.toLowerCase()) {
                  tempArtModel.name = artis.artists.items[0].name ? artis.artists.items[0].name : '';
                  tempArtModel.followers = artis.artists.items[0].followers.total ? artis.artists.items[0].followers.total : '';
                  tempArtModel.popularity = artis.artists.items[0].popularity ? artis.artists.items[0].popularity : '';
                  tempArtModel.checkat = artis.artists.items[0].external_urls.spotify ? artis.artists.items[0].external_urls.spotify : '';
                  this.artistModel.push(tempArtModel);
                  check = 1;
                }


              }

            }


            }
        if (check === 0) {
          this.artistModel.push(tempArtModel);
        } else {
          check = 0;
        }


        }



      } else {
        this.artistModel = [];
      }
    });



  }

}
