import { Component, OnInit } from '@angular/core';
import {ShowPagesService} from '../services/showPages.service';
import {ObservabService} from '../services/observab.service';
import {ASingleEventModel} from '../result-table/aSingleEvent.model';
import {EventEmitteService} from '../services/eventEmitte.service';
import { trigger, transition, useAnimation } from '@angular/animations';
import { slideInRight, slideOutRight, slideInLeft } from 'ng-animate';
@Component({
  selector: 'app-detail',
  templateUrl: './detail.component.html',
  styleUrls: ['./detail.component.css'],
  animations: [
    trigger('slideInRight', [transition('void => *', useAnimation(slideInRight, {
      params: {
        opacity: '100%',
        timing: 0.3,
        delay: 0
      }
    }))]),

  ],

})
export class DetailComponent implements OnInit {
  detailAndListButton: string;
  tabId = 'event';
  eventModel: any;
  twitterText: string;
  twitterTextData = new Array();

  favoriteData: any;
  favoritecheck = false;

  widthh = '0';

  theJSONINFO: any;
  thesIngleJson: any;

  changePage = 'open';
  constructor(private showPageService: ShowPagesService, private observBale: ObservabService, private eventEmit: EventEmitteService) { }



  ngOnInit() {
    this.widthh = '50%';

    this.observBale.eventData.subscribe( respp => {
      if (respp.hasOwnProperty('name')) {

        this.thesIngleJson = respp;
      }

    });

    this.eventEmit.changeDetailEvent.subscribe( resp => {
      if (resp === 'clear') {
        this.detailAndListButton = '';
        this.tabId = 'event';
        //this.eventModel;
        this.twitterText = '';
        this.twitterTextData = new Array();

        this.favoritecheck = false;

        this.changePage = 'open';
        this.widthh = '50%';


      }

    });

    this.observBale.obtainedCheckInfomation.subscribe( respons => {

      this.changePage = respons;
      console.log(this.changePage);

    });

    this.observBale.theFavoriteModel.subscribe( resp => {

      // this.favoriteData = resp;
      if  (resp.event !== '') {
        this.favoriteData = resp;
        if (resp.hasOwnProperty('favorite')) {
          this.favoritecheck = resp.favorite;
        }
      }

    });
    this.observBale.obtainedSingleJsonFile.subscribe( resppp => {
      this.theJSONINFO = resppp;
      if (resppp.hasOwnProperty('name')) {

        // console.log(1111);
      }
    });


    //this.getData();
    this.observBale.twitterObverver.subscribe( resp => {
      if (resp.length === 3) {
        this.twitterText = 'Check out ' + resp[0] + ' located at ' + resp[1]
          + '. Website: ' + resp[2] + encodeURIComponent('#CSCI571EventSearch');
        console.log(this.twitterText);
      }
    });

    this.showPageService.detailAndListButton.subscribe(response => {
      this.detailAndListButton = response;

    });

    this.showPageService.listToDetailPage.subscribe( res => {


      if (res === 'detail2') {
        this.detailAndListButton = 'detail';

      } else if (res === 'detail') {
        this.tabId = 'event';
        this.detailAndListButton = 'detail';
        //console.log(11111);
        setTimeout(() => {
          this.widthh = '0';
        }, 200);

      }


    });

    this.observBale.modell.subscribe( response => {
      this.eventModel = response;
    });

  }

  checkEventFavStatus() {
    if (this.favoritecheck === false) {
      this.favoritecheck = true;
      this.favoriteData.favorite = true;
      this.observBale.methodtoSendfavFromDetail(this.favoriteData);
      localStorage.setItem(this.theJSONINFO[0], JSON.stringify(this.theJSONINFO[1]));


    } else {

      this.favoritecheck = false;
      this.favoriteData.favorite = false;
      this.observBale.methodtoSendfavFromDetail(this.favoriteData);
      localStorage.removeItem(this.theJSONINFO[0]);

    }
  }


  changeTab (str: string) {
    this.tabId = str;
  }

  backToList (str: string) {
    this.showPageService.detailAndListButton.emit('list');
    this.showPageService.listToDetailPage.emit(['0', 'showPage']);
    this.observBale.sendPageREFAinfo('close');
  }

}
