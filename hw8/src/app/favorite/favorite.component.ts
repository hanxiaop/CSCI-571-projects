import { Component, OnInit } from '@angular/core';
import {ASingleEventModel} from '../result-table/aSingleEvent.model';
import {AddFavoriteService} from '../services/addFavorite.service';
import {ShowPagesService} from '../services/showPages.service';
import {ObservabService} from '../services/observab.service';
import {ClitoServerService} from '../services/clitoServer.service';
import { trigger, transition, useAnimation } from '@angular/animations';
import {slideInRight, slideOutLeft, slideOutRight, slideInLeft} from 'ng-animate';
import {EventEmitteService} from '../services/eventEmitte.service';
@Component({
  selector: 'app-favorite',
  templateUrl: './favorite.component.html',
  styleUrls: ['./favorite.component.css'],
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
export class FavoriteComponent implements OnInit {
  eventsArray = [];
  // detailAndListButton2: string = 'detaildisabled';
  detailAndListButton = 'detaildisabled';
  showPage = 'showPage';
  hoverActive = new Array();

  checkColorArr = new Array();

  chechPage = '';

  constructor(private showPageService: ShowPagesService, private observBale: ObservabService,
              private favoriteService: AddFavoriteService, private eventEmit: EventEmitteService,
              private cliToServer: ClitoServerService) { }

  ngOnInit() {

    this.eventEmit.changeDetailEvent.subscribe( resp =>{
      if (resp === 'clear') {
        if (this.eventsArray.length !== 0) {
          this.detailAndListButton = 'detaildisabled';
        }

      }

    });


    this.observBale.obtainedCheckInfomation.subscribe(resp => {
      if (resp === 'close') {
        this.chechPage = 'open';
        // showPage
        this.showPage = 'showPage';
      } else if (resp === 'open') {
        this.chechPage = 'close';

      }
    });


    //localStorage.clear();
    this.showPageService.detailAndListButton.subscribe(response => {
      this.detailAndListButton = response;
    });

    this.showPageService.listToDetailPage.subscribe( response => {
      //this.widthh = response[0];
      this.showPage = response[1];
    });
     //localStorage.clear();

    // localStorage.clear();

    this.observBale.sendFavtoListAndFavoResult.subscribe( resp => {
      if (resp.event !== '') {
        // localStorage.setItem(resp.event, JSON.stringify(resp));

        if (resp.favorite === true) {
          localStorage.setItem(resp.event , JSON.stringify(resp));

          this.eventsArray.push(resp);

          const eventName = resp.event;
          if (localStorage.getItem('nameArray')) {
            const nameAry = JSON.parse(localStorage.getItem('nameArray'));
            nameAry.push(eventName);
            localStorage.setItem('nameArray', JSON.stringify(nameAry));
          } else {
            const nameArray = new Array();
            nameArray.push(eventName);
            localStorage.setItem('nameArray', JSON.stringify(nameArray));
          }


        } else if (resp.favorite === false) {
          let indexNum;
          for (let i = 0; i < this.eventsArray.length; i++) {
            if (resp.event === this.eventsArray[i].event) {
              indexNum = i;
              break;
            }
          }
          // console.log(this.eventsArray[indexNum]);
          if (this.eventsArray[indexNum]) {
            localStorage.removeItem(this.eventsArray[indexNum].event);
            const oldNameArr = JSON.parse(localStorage.getItem('nameArray'));
            const index = oldNameArr.indexOf(this.eventsArray[indexNum].event);
            this.eventsArray = this.eventsArray.filter(obj => obj !== this.eventsArray[indexNum]);


            if (index !== -1) {
              oldNameArr.splice(index, 1);
            }
            console.log(oldNameArr);
            localStorage.setItem('nameArray', JSON.stringify(oldNameArr));
          }


        }


      }
    });

    this.favoriteService.favoriteButton.subscribe( response => {
      // console.log(response);

      if (response) {

        localStorage.setItem(response.event , JSON.stringify(response));

        this.eventsArray.push(response);

        const eventName = response.event;
        if (localStorage.getItem('nameArray')) {
          const nameAry = JSON.parse(localStorage.getItem('nameArray'));
          nameAry.push(eventName);
          localStorage.setItem('nameArray', JSON.stringify(nameAry));
        } else {
          const nameArray = new Array();
          nameArray.push(eventName);
          localStorage.setItem('nameArray', JSON.stringify(nameArray));
        }
      }
      console.log(localStorage.getItem('nameArray'));
    });
    this.favoriteService.deleteFavorite.subscribe( response => {
      let indexNum;
      for (let i = 0; i < this.eventsArray.length; i++) {
        if (response === this.eventsArray[i].event) {
          indexNum = i;
          break;
        }
      }
      // console.log(this.eventsArray[indexNum]);
      localStorage.removeItem(this.eventsArray[indexNum].event);
      const oldNameArr = JSON.parse(localStorage.getItem('nameArray'));
      const index = oldNameArr.indexOf(this.eventsArray[indexNum].event);
      this.eventsArray = this.eventsArray.filter(obj => obj !== this.eventsArray[indexNum]);




      if (index !== -1) {
        oldNameArr.splice(index, 1);
      }
      console.log(oldNameArr);
      localStorage.setItem('nameArray', JSON.stringify(oldNameArr));

    });

    //
    // if (localStorage.getItem('nameArray')){
    //   let nameArray = JSON.parse(localStorage.getItem('nameArray'));
    //   for (let singleName of nameArray) {
    //     if (!localStorage.getItem(na))
    //   }
    // }



    if (localStorage.getItem('nameArray')) {
      //   // localStorage.clear();
      const names = JSON.parse(localStorage.getItem('nameArray'));
      if (names.length === 0) {

        localStorage.clear();
        this.eventsArray = [];
      }


      //   console.log(names);
      for (let name of names) {
        this.eventsArray.push(JSON.parse(localStorage.getItem(name)));
        this.hoverActive.push(false);
      }
    } else if (localStorage.length !== 0) {
      localStorage.clear();
      this.eventsArray = [];
    }

    console.log(localStorage.getItem('nameArray'));
    console.log(this.eventsArray);

  }
  deleteEvent(num: number) {
    const nameOfEvent = this.eventsArray[num].event;
    const sendToDetail = this.eventsArray[num];

    const nameArr = JSON.parse(localStorage.getItem('nameArray'));

    const indexArr = nameArr.indexOf(nameOfEvent);
    if (indexArr !== -1) {
      nameArr.splice(indexArr, 1);
      this.favoriteService.favDeletCheck.emit(nameOfEvent);
      this.observBale.sendFavoriteModelmethod(sendToDetail);

      this.eventsArray = this.eventsArray.filter(obj => obj !== this.eventsArray[num]);
      localStorage.setItem('nameArray', JSON.stringify(nameArr));
      localStorage.removeItem(nameOfEvent + nameOfEvent);
      localStorage.removeItem(nameOfEvent);


    }


  }
  showThePage(str: string) {
    // this.showPageService.detailAndListButton.emit(str);
    this.showPageService.listToDetailPage.emit(str);
    this.detailAndListButton = 'notShown';
    this.observBale.sendPageREFAinfo('open');
  }


  goTodetail(index: number) {
    this.observBale.sendPageREFAinfo('open');

    this.eventsArray[index].favoCheck = 'changeColor';
    this.observBale.modelPass(this.eventsArray[index]);
    this.observBale.saveDefault('Default');
    this.observBale.saveAscending('Ascending');
    this.showPage = '';
    this.showPageService.listToDetailPage.emit('detail');

    const orderedRequestArray = new Array();
    const totalGoogle = new Array();
    const artistList = new Array();

    const theJSONfile = JSON.parse(localStorage.getItem(this.eventsArray[index].event + this.eventsArray[index].event));
    //console.log(theJSONfile);
    // this.checkColorArr[index] = index;

    // event page
    // this.transferData.listTableToEvent.emit(theJSONfile);

     this.observBale.passseventInfo(theJSONfile);
     console.log(this.eventsArray[index].event + this.eventsArray[index].event);

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


