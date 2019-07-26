import { Component, OnInit } from '@angular/core';
import {VenueInfoModel} from './venueInfo.model';
import {TransferDataService} from '../../services/transferData.service';
import {ObservabService} from '../../services/observab.service';

@Component({
  selector: 'app-venue',
  templateUrl: './venue.component.html',
  styleUrls: ['./venue.component.css']
})
export class VenueComponent implements OnInit {
  data = new VenueInfoModel('', '', '',
    '', '', '', '');
  lat: any;
  lng: any;
  constructor(private transferData: TransferDataService, private obServab: ObservabService) { }

  ngOnInit() {
    // this.transferData.listTableToVene.subscribe( res => {
    //   console.log(res);
    //   console.log(222);
    // });

    this.obServab.currentData.subscribe( resp => {
      if (resp) {
        if ( resp.hasOwnProperty('_embedded')) {
          console.log(resp);

          let tempData: any = resp;
          this.data.name = tempData._embedded.venues[0].name;
          this.data.phoneNumber = tempData._embedded.venues[0].hasOwnProperty('boxOfficeInfo')
            ? tempData._embedded.venues[0].boxOfficeInfo.phoneNumberDetail : '';
          this.data.address = tempData._embedded.venues[0].address.line1 ? tempData._embedded.venues[0].address.line1 : '';
          this.data.city = tempData._embedded.venues[0].city.name
             + ', ' + tempData._embedded.venues[0].state.name;
          this.data.openhours = tempData._embedded.venues[0].hasOwnProperty('boxOfficeInfo')
            ? tempData._embedded.venues[0].boxOfficeInfo.openHoursDetail : '';
          this.data.generalRule = tempData._embedded.venues[0].hasOwnProperty('generalInfo')
            ? tempData._embedded.venues[0].generalInfo.hasOwnProperty('generalRule')
              ? tempData._embedded.venues[0].generalInfo.generalRule : '' : '';
          this.data.childRukle = tempData._embedded.venues[0].hasOwnProperty('generalInfo')
            ? tempData._embedded.venues[0].generalInfo.hasOwnProperty('childRule')
              ?  tempData._embedded.venues[0].generalInfo.childRule : '' : '';
          this.lat = parseFloat(tempData._embedded.venues[0].location.latitude);

          this.lng = parseFloat(tempData._embedded.venues[0].location.longitude);
        }

      }
    });

  }



}
