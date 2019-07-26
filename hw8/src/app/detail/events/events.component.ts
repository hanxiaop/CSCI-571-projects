import { Component, OnInit } from '@angular/core';
import {EventDetailModelModel} from './eventDetailModel.model';
import {TransferDataService} from '../../services/transferData.service';
import {ObservabService} from '../../services/observab.service';
import * as moment from 'moment';

@Component({
  selector: 'app-events',
  templateUrl: './events.component.html',
  styleUrls: ['./events.component.css']
})
export class EventsComponent implements OnInit {
  theObj: any; // = new EventDetailModelModel('11', '22', '33', '44', '55', '66', '77', '88');

  constructor(private transferData: TransferDataService, private observBale: ObservabService) { }

  ngOnInit() {
    //localStorage.clear();

    this.observBale.eventData.subscribe( res => {
      let tempModel = new EventDetailModelModel('', '', '', '', '',
        '', '', '');
      if (res.hasOwnProperty('name')) {

        let tempFile: any = res;

        for (let name1 of tempFile._embedded.attractions) {
          tempModel.artist += (name1.name) + ' | ';
        }
        tempModel.artist = tempModel.artist.substring(0, tempModel.artist.length - 2);
        tempModel.venue = tempFile._embedded.venues[0].name;
        if (tempFile.dates) {
          tempModel.time += moment(tempFile.dates.start.localDate).format('ll');
          if (tempFile.dates.start.localTime) {
            tempModel.time += '  ' + (tempFile.dates.start.localTime);
          }
        }
        if (tempFile._embedded.attractions[0].classifications[0].segment) {
          tempModel.category += (tempFile._embedded.attractions[0].classifications[0].segment.name) + ' | ';
        }
        if (tempFile._embedded.attractions[0].classifications[0].genre) {
          tempModel.category += (tempFile._embedded.attractions[0].classifications[0].genre.name);
        }
        if (tempFile.priceRanges) {
          tempModel.priceRange += (tempFile.priceRanges[0].min ? '$' + tempFile.priceRanges[0].min : '');
          tempModel.priceRange += ' ~ ';
          tempModel.priceRange += (tempFile.priceRanges[0].max ? '$' + tempFile.priceRanges[0].max : '');
        }
        tempModel.ticketStatus = tempFile.dates.status.code;
        if (tempFile.url) {
          tempModel.byTicket = tempFile.url;
        }
        if (tempFile.seatmap) {
          tempModel.seatMap = tempFile.seatmap.staticUrl;
        }
        this.theObj = tempModel;

      }


    });


  }





}
