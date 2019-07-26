import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import {ASingleEventModel} from '../result-table/aSingleEvent.model';

@Injectable()
export class ObservabService {

  private venu = new BehaviorSubject('default message');
  currentData = this.venu.asObservable();

  private artistName = new BehaviorSubject('default message');
  currentDataartistName = this.artistName.asObservable();

  private artistGoogle = new BehaviorSubject('default message');
  artistGdata = this.artistGoogle.asObservable();

  private artistSpotify = new BehaviorSubject('default message');
  artistSpotifyData = this.artistSpotify.asObservable();

  private event = new BehaviorSubject('default message');
  eventData = this.event.asObservable();

  private upcomingEvent = new BehaviorSubject('default message');
  upcomingData = this.upcomingEvent.asObservable();

  private theModelToDetail = new BehaviorSubject('default message');
  modell = this.theModelToDetail.asObservable();


  private twitterStr = new BehaviorSubject('default message');
  twitterObverver = this.twitterStr.asObservable();


  private default = new BehaviorSubject('Default');
  defaultmess = this.default.asObservable();
  private ascending = new BehaviorSubject('Ascending');
  ascendingmess = this.ascending.asObservable();


  private sendFavoriteModel = new BehaviorSubject(new ASingleEventModel('', '', '', '', false));
  theFavoriteModel = this.sendFavoriteModel.asObservable();

  private detailSendFavorite = new BehaviorSubject(new ASingleEventModel('', '', '', '', false));
  sendFavtoListAndFavoResult = this.detailSendFavorite.asObservable();


  private passJSONfile = new BehaviorSubject([]);
  obtainedSingleJsonFile = this.passJSONfile.asObservable();



  private  checkthePage = new BehaviorSubject('default');
  obtainedCheckInfomation = this.checkthePage.asObservable();


  private clearAllInfo = new BehaviorSubject('default');
  theClearMessage = this.clearAllInfo.asObservable();

  constructor() { }
  clearAllInfoMethod(message: any) {
    this.clearAllInfo.next(message);
  }


  sendPageREFAinfo(message: any) {
    this.checkthePage.next(message);
  }

  sendtheJSONmethod(message: any) {
    this.passJSONfile.next(message);
  }


  methodtoSendfavFromDetail(message: ASingleEventModel) {
    this.detailSendFavorite.next(message);
  }

  passVeneInfo(message: any) {
    this.venu.next(message);
  }

  passartistName(message: any) {
    this.artistName.next(message);
  }

  passGoogleInfo(message: any) {
    this.artistGoogle.next(message);
  }

  passaspotifyInfo(message: any) {
    this.artistSpotify.next(message);
  }

  passseventInfo(message: any) {
    this.event.next(message);
  }

  passupcomingInfo(message: any) {
    this.upcomingEvent.next(message);
  }

  modelPass (message: any) {
    this.theModelToDetail.next(message);
  }


  saveDefault (message: any) {
    this.default.next(message);
  }
  saveAscending (message: any) {
    this.ascending.next(message);
  }


  sendTwitter (message: any) {
    this.twitterStr.next(message);
  }


  sendFavoriteModelmethod (message: ASingleEventModel) {
    this.sendFavoriteModel.next(message);
  }


}
