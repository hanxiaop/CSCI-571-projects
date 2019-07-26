import { Component, OnInit } from '@angular/core';
import {ASingleEventModel} from './aSingleEvent.model';
import {ShowPagesService} from '../services/showPages.service';
import {AddFavoriteService} from '../services/addFavorite.service';
import {ClitoServerService} from '../services/clitoServer.service';
import {TransferDataService} from '../services/transferData.service';
import {ObservabService} from '../services/observab.service';
import {EventEmitteService} from '../services/eventEmitte.service';
import { trigger, transition, useAnimation } from '@angular/animations';
import {slideInRight, slideOutLeft, slideOutRight, slideInLeft} from 'ng-animate';

@Component({
  selector: 'app-result-table',
  templateUrl: './result-table.component.html',
  styleUrls: ['./result-table.component.css'],
  animations: [
    trigger('slideInLeft', [transition('void => *', useAnimation(slideInLeft, {
      params: {
        opacity: '100%',
        timing: 0.3,
        delay: 0,

      }
    }))]),
  ],

})
export class ResultTableComponent implements OnInit {
  detailAndListButton: string = 'detaildisabled';
  widthh = '0';
  showPage = '1';

  savedNameArray = new Array();
  checkColorArr = new Array();
  resultData = new Array();
  allJSONdata = new Array();
  hoverActive = new Array();


  eventsArray = [
    // new ASingleEventModel('2019-08-10', 'Lakers', 'Sports', 'STAPLES center', false),
    // new ASingleEventModel('2019-08-10', 'Lakerss', 'Sports', 'STAPLES center', false),
    // new ASingleEventModel('2019-08-10', 'rocket', 'Sports', 'STAPLES center', false),
    // new ASingleEventModel('2019-08-10', 'golden', 'Sports', 'STAPLES center', false)
    ];


  constructor(private showPageService: ShowPagesService, private addFavorite: AddFavoriteService,
              private cliToServer: ClitoServerService, private transferData: TransferDataService,
              private observBale: ObservabService, private eventEmit: EventEmitteService) {

  }

  ngOnInit() {
    this.observBale.sendPageREFAinfo('close');


    this.eventEmit.changeDetailEvent.subscribe( resp =>{
      if (resp === 'clear') {
        if (this.eventsArray.length !== 0) {
          this.eventsArray = [];
          this.detailAndListButton = 'detaildisabled';
          this.widthh = '0';
          this.showPage = '1';
          this.savedNameArray = new Array();
          this.checkColorArr = new Array();
          this.resultData = new Array();
          this.allJSONdata = new Array();
          this.hoverActive = new Array();
        }


      }


    });


    this.observBale.obtainedCheckInfomation.subscribe(resp => {
      if (resp === 'close') {
        if (this.eventsArray.length === 0) {

        } else {
          this.showPage = 'showPage';
        }

      }
    });




    this.observBale.sendFavtoListAndFavoResult.subscribe( resp => {
      if (resp.event !== '') {
        if (resp.favorite) {
          for (let i = 0; i < this.eventsArray.length; i++) {
            if (this.eventsArray[i].event === resp.event) {
              this.eventsArray[i].favorite = resp.favorite;
            }

          }
        }
      }
    });


    this.showPageService.detailAndListButton.subscribe(response => {
      this.detailAndListButton = response;
    });

    this.showPageService.searchFormToResult.subscribe( response => {
      this.widthh = '50%';
      this.showPage = response;
    });
    this.showPageService.listToDetailPage.subscribe( response => {
      this.widthh = response[0];
      this.showPage = response[1];
    });

    this.transferData.searchFormToList.subscribe( response => {

      if (response) {
        if (response.hasOwnProperty('_embedded')) {

          for (let evt of response._embedded.events) {
            this.checkColorArr.push('');
          }

          for (let evt of response._embedded.events) {
            this.allJSONdata.push(evt);
            this.savedNameArray.push(evt.name);
            this.checkColorArr.push('');
            this.hoverActive.push(false);

            let tempModel: ASingleEventModel = new ASingleEventModel('', '', '', '', false);
            console.log(evt);
            tempModel.date = evt.dates.start.localDate;
            tempModel.category = (evt.classifications[0].hasOwnProperty('genre') ? evt.classifications[0].genre.name + '-' : '')
              + evt.classifications[0].segment.name;
            tempModel.eventLong = evt.name;
            if (tempModel.eventLong.length > 30) {
              let tempIndex = 29;
              for (let i = 29; i < tempModel.eventLong.length - 1; i++) {
                if (tempModel.eventLong.charAt(i) === ' ') {
                  tempIndex = i + 1;
                  break;
                }
              }
              tempModel.event = tempModel.eventLong.substring(0, tempIndex) + '...';
            }

            tempModel.favorite = false;
            tempModel.venue = evt._embedded.venues[0].name;

            this.resultData.push(tempModel);
          }

          this.resultData.sort((a, b) => a.date < b.date ? -1 : 1);
          this.allJSONdata.sort((a, b) => a.dates.start.localDate < b.dates.start.localDate ? -1 : 1);
          this.eventsArray = this.resultData;
           console.log(this.eventsArray);
           console.log(this.allJSONdata);
          this.widthh = '0';

        } else {
          this.widthh = '0';
          this.eventsArray = [];
          this.showPage = 'noresultes';
        }

      }
    });


    this.addFavorite.favDeletCheck.subscribe( response => {
      for (let i = 0; i < this.eventsArray.length; i++) {
        if (this.eventsArray[i].event === response) {

          this.eventsArray[i].favorite = false;
          break;
        }

      }

    });

  }




  showThePage(str: string) {
    // this.showPageService.detailAndListButton.emit(str);
    this.showPageService.listToDetailPage.emit(str);
    this.detailAndListButton = 'notShown';
    this.observBale.sendPageREFAinfo('open');
  }



  checkEventFavStatus(num: string) {
    // console.log(num);
    let theEvent = this.eventsArray[num];

    if (theEvent.favorite === false) {
      this.eventsArray[num].favorite = true;
      this.addFavorite.favoriteButton.emit(theEvent);
      let jsonDataArray = new Array();
      let jsonFullNameARR = new Array();
      let jsonShortNameARR = new Array();
      for (let i = 0; i< this.savedNameArray.length; i++) {
        if (this.savedNameArray[i].favorite === true) {
          jsonDataArray.push(this.allJSONdata[i]);
          jsonFullNameARR.push(this.savedNameArray[i].eventLong);
          jsonShortNameARR.push(this.savedNameArray[i].event);
        }

      }
      localStorage.setItem(this.eventsArray[num].event + this.eventsArray[num].event, JSON.stringify(this.allJSONdata[num]));
      console.log(this.eventsArray[num].event + this.eventsArray[num].event);
      this.observBale.sendtheJSONmethod([jsonDataArray, jsonFullNameARR, jsonShortNameARR]);

      this.observBale.sendFavoriteModelmethod(theEvent);
      // console.log(theEvent.event);
    } else {
      localStorage.removeItem(this.eventsArray[num].event + this.eventsArray[num].event);
      this.eventsArray[num].favorite = false;
      this.addFavorite.deleteFavorite.emit(theEvent.event);
      this.observBale.sendFavoriteModelmethod(theEvent);

    }

  }


  goTodetail(index: number) {
    this.observBale.sendPageREFAinfo('open');
    // this.hoverActive[index] = true;
    if (this.eventsArray[index].favorite === true) {
      localStorage.setItem(this.eventsArray[index].event + this.eventsArray[index].event, JSON.stringify(this.allJSONdata[index]));
      this.observBale.sendtheJSONmethod([this.eventsArray[index].event + this.eventsArray[index].event, this.allJSONdata[index]]);
    }


    this.observBale.modelPass(this.eventsArray[index]);
    this.observBale.saveDefault('Default');
    this.observBale.saveAscending('Ascending');
    this.showPage = '';
    this.showPageService.listToDetailPage.emit('detail');

    const orderedRequestArray = new Array();
    const totalGoogle = new Array();
    const artistList = new Array();

    const theJSONfile = this.allJSONdata[index];
    this.checkColorArr[index] = index;

    // event page
    this.observBale.passseventInfo(theJSONfile);



    // artist page
    if (theJSONfile.classifications[0].segment.name === 'Music') {

      for (let names of theJSONfile._embedded.attractions) {

        //console.log(names.name);

        this.cliToServer.sendRequestSPOtiAPI(names.name).subscribe(
          retriveData => {

              //this.transferData.listTableToArtistSPO.emit(retriveData);
            artistList.push(retriveData);
          }
        );
      }
      this.observBale.passaspotifyInfo(artistList);
    }
    for (let names2 of theJSONfile._embedded.attractions) {
      //console.log(names2.name);
      orderedRequestArray.push(names2.name);
      this.cliToServer.sendGoogleRequest(names2.name, 'image').subscribe(theImage => {
        //this.transferData.listTat
        totalGoogle.push(theImage);
        // console.log(theImage);
      });

    }
    this.observBale.passGoogleInfo(totalGoogle);


    //this.transferData.listTableToArtisName.emit(orderedRequestArray);
      this.observBale.passartistName(orderedRequestArray);

    // venuePage
    this.cliToServer.sendRequestToVene(theJSONfile._embedded.venues[0].name).subscribe(responseV => {
      //console.log(theJSONfile._embedded.venues[0].name);

      //this.transferData.listTableToVene.emit(responseV);
      this.observBale.passVeneInfo(responseV);

    });
    //console.log(theJSONfile._embedded.venues[0].name);

    // upcomingEvt
    this.cliToServer.sendRequestSongKick(theJSONfile._embedded.venues[0].name)
      .subscribe(response => {
        //this.transferData.listTableToUpcoming.emit(response);
          this.observBale.passupcomingInfo(response);
      });

    this.observBale.sendTwitter([theJSONfile.name, theJSONfile._embedded.venues[0].name, theJSONfile.url]);

    this.observBale.sendFavoriteModelmethod(this.eventsArray[index]);


  }



}
