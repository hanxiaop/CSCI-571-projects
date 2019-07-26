import { Component, OnInit } from '@angular/core';
import {TransferDataService} from '../../services/transferData.service';
import {EventsModel} from './events.model';
import * as moment from 'moment';
import {ObservabService} from '../../services/observab.service';
import {trigger, transition, useAnimation, state, style} from '@angular/animations';
import {fadeInDown, fadeOutUp, slideOutRight, slideInLeft} from 'ng-animate';
@Component({
  selector: 'app-upcomingevent',
  templateUrl: './upcomingevent.component.html',
  styleUrls: ['./upcomingevent.component.css'],
  animations: [
    trigger('fadeAnim', [
      state('normal', style({

      })),
      state('closepage', style({

      })),
      transition('void => *', useAnimation(fadeInDown, {
      // Set the duration to 5seconds and delay to 2seconds
      params: { timing: 1, delay: 0}
    })),
      transition('* => void', useAnimation(fadeOutUp, {
        // Set the duration to 5seconds and delay to 2seconds
        params: { timing: 1, delay: 0}
      }))

    ]),

  ],
})
export class UpcomingeventComponent implements OnInit {
  defaultSort: string = 'Default';

  showEvt = 'normal';

  resultArray = new Array();
  resultArray2 = new Array();

  restArray = new Array();
  restArray2 = new Array();
  totalARRAY = new Array();

  defalutAscending: string = 'Ascending';

  noDataMessage = 'have';

  tempRestArray = new Array();
  constructor(private transferData: TransferDataService, private observBale: ObservabService) { }

  ngOnInit() {

    this.observBale.upcomingData.subscribe( resp => {
      // console.log(res);
      if (resp.hasOwnProperty('resultsPage')) {
        console.log(resp);
        let temFile: any = resp;
        if (temFile.resultsPage.results.hasOwnProperty('event')) {

          for (let events of temFile.resultsPage.results.event) {
            var tempModel = new EventsModel('', '', '', '', '', '', '');
            tempModel.name = events.displayName;
            tempModel.uri = events.uri;
            tempModel.artist = events.performance[0].displayName;
            tempModel.date = moment(events.start.date).format('ll');
            tempModel.time = events.start.time !== null ? events.start.time : '';
            tempModel.type = events.type;
            tempModel.comparedate = events.start.date + ' ' + (events.start.time !== null ? events.start.time : '00:00:00');

            if (this.resultArray.length < 5) {
              this.resultArray.push(tempModel);
              this.resultArray2.push(tempModel);
              this.totalARRAY.push(tempModel);
            } else {
              this.restArray.push(tempModel);
              this.totalARRAY.push(tempModel);
              this.restArray2.push(tempModel);
            }

          }

        } else {
          this.noDataMessage = 'noData';
          console.log(this.noDataMessage);
        }



      } else {
        this.noDataMessage = 'noData';
        console.log(this.noDataMessage);
      }
    });


    this.observBale.ascendingmess.subscribe( resp => {
      this.defalutAscending = resp;
    });
    this.observBale.defaultmess.subscribe( resp => {
      this.defaultSort = resp;
    });
    this.changeSort();

  }


  changeSort() {
    if (this.defaultSort === 'Default') {
      this.resultArray = this.resultArray2;
      this.restArray = this.restArray2;
      this.observBale.saveDefault('Default');
      this.observBale.saveAscending('Ascending');
    } else if (this.defaultSort === 'Event Name') {
      if (this.defalutAscending === 'Ascending') {
        this.totalARRAY.sort((a, b) => a.name.localeCompare(b.name));
        this.resultArray = this.totalARRAY.slice(0, 5);
        this.restArray = this.totalARRAY.slice(5, -1);
        this.observBale.saveDefault('Event Name');
        this.observBale.saveAscending('Ascending');
      } else {
        this.totalARRAY.sort((a, b) => b.name.localeCompare(a.name));
        this.resultArray = this.totalARRAY.slice(0, 5);
        this.restArray = this.totalARRAY.slice(5, -1);
        this.observBale.saveDefault('Event Name');
        this.observBale.saveAscending('Descending');
      }

    } else if (this.defaultSort === 'Time') {
      if (this.defalutAscending === 'Ascending') {
        this.totalARRAY.sort((a, b) => a.comparedate < b.comparedate ? -1 : 1);
        this.resultArray = this.totalARRAY.slice(0, 5);
        this.restArray = this.totalARRAY.slice(5, -1);
        this.observBale.saveDefault('Time');
        this.observBale.saveAscending('Ascending');
      } else {
        this.totalARRAY.sort((a, b) => a.comparedate < b.comparedate ? 1 : -1);
        this.resultArray = this.totalARRAY.slice(0, 5);
        this.restArray = this.totalARRAY.slice(5, -1)
        this.observBale.saveDefault('Time');
        this.observBale.saveAscending('Descending');
      }
    } else if (this.defaultSort === 'Artist') {
      if (this.defalutAscending === 'Ascending') {
        this.totalARRAY.sort((a, b) => a.artist.localeCompare(b.artist));
        this.resultArray = this.totalARRAY.slice(0, 5);
        this.restArray = this.totalARRAY.slice(5, -1);
        this.observBale.saveDefault('Artist');
        this.observBale.saveAscending('Ascending');
      } else {
        this.totalARRAY.sort((a, b) => b.artist.localeCompare(a.artist));
        this.resultArray = this.totalARRAY.slice(0, 5);
        this.restArray = this.totalARRAY.slice(5, -1);
        this.observBale.saveDefault('Artist');
        this.observBale.saveAscending('Descending');
      }

    } else if (this.defaultSort === 'Type') {
      if (this.defalutAscending === 'Ascending') {
        this.totalARRAY.sort((a, b) => a.type.localeCompare(b.type));
        this.resultArray = this.totalARRAY.slice(0, 5);
        this.restArray = this.totalARRAY.slice(5, -1);
        this.observBale.saveDefault('Type');
        this.observBale.saveAscending('Ascending');


      } else {
        this.totalARRAY.sort((a, b) => b.type.localeCompare(a.type));
        this.resultArray = this.totalARRAY.slice(0, 5);
        this.restArray = this.totalARRAY.slice(5, -1);
        this.observBale.saveDefault('Type');
        this.observBale.saveAscending('Descending');
      }
    }


  }


  showEvent(str: string) {
    this.showEvt = this.showEvt === 'normal' ? 'closepage' : 'normal';
    if (this.tempRestArray.length === 0) {
      this.tempRestArray = this.restArray;

    } else {

      for (let i = this.tempRestArray.length; i >= 0; i--) {
        this.tempRestArray = this.tempRestArray.slice(0, i);
      }


    }
  }

}
