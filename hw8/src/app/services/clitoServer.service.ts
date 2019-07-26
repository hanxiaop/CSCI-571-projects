
import { HttpClient} from '@angular/common/http';
import {Injectable} from '@angular/core';

import {Observable} from 'rxjs';


@Injectable()
export class ClitoServerService {
  private keyword0;
  private keyword: string;
  private spotikeyword: string;
  private googleKeyword: string;
  private distance: string;
  private category: string;
  private hereLocation: string;
  private hereLoc: string;
  private searchType: string;
  private venuekeyword: string;
  private songkick: string;

  constructor( private http: HttpClient) { }

  getLocation() {
    return this.http.get('http://ip-api.com/json');
  }
  sendRequest(astr: string): Observable<any> {
    this.keyword0 = astr.replace(' ', '+' );
    return this.http.get<Object>('/apiRequest?autoCompkeyword=' + this.keyword0);

  }



  sendRequestSearchEvent(searchForm): Observable<any> {
    this.keyword = searchForm.keyword.replace(' ', '+' );
    this.distance = searchForm.distance;
    this.category = searchForm.category;



    this.hereLocation = searchForm.hereLocationValue;
    this.hereLoc = this.hereLocation.replace(',', '+');


    if (searchForm.hereLocation === true) {

      return this.http.get<Object>('/apiRequest?keyword=' + this.keyword + '&distance=' + this.distance
        + '&category=' + this.category + '&unit=' + searchForm.unit.toLowerCase() + '&herelocation=' + this.hereLoc);

    } else {
      // this.ecodedGeo = searchForm.locationValue.replace(' ', '+');


      return this.http.get<Object>('/apiRequest?keyword=' + this.keyword + '&distance=' + this.distance
        + '&category=' + this.category + '&unit=' + searchForm.unit.toLowerCase() + '&locationtype='
        + searchForm.locationValue.replace(' ' , '+'));

    }

  }


  sendRequestSPOtiAPI(astr: string): Observable<any> {
    this.spotikeyword = astr.replace(' ', '+' );
    //console.log(this.http.get<Object>('/apiRequest?keyword=' + this.spotikeyword));
    return this.http.get<Object>('/apiRequest?keyword=' + this.spotikeyword);

  }




  sendGoogleRequest(astr: string, type: string): Observable<any> {
    this.googleKeyword = astr.replace(' ', '+' );
    this.searchType = type;
    //console.log('/apiRequest?keyword=' + this.googleKeyword + '&searchType=' + this.searchType);
    return this.http.get<Object>('/apiRequest?keyword=' + this.googleKeyword + '&searchType=' + this.searchType);

  }

  sendRequestToVene(astr: string): Observable<any> {
    this.venuekeyword = astr.replace(' ', '+' );
    //console.log('/apiRequest?venuekeyword=' + this.venuekeyword);
    return this.http.get<Object>('/apiRequest?venuekeyword=' + this.venuekeyword);

  }


  sendRequestSongKick(astr: string): Observable<any> {
    this.songkick = astr.replace(' ', '+' );
   // console.log('/apiRequest?songkickReq=' + this.songkick);
    return this.http.get<Object>('/apiRequest?songkickReq=' + this.songkick);

  }





}
