import { Component, OnInit } from '@angular/core';
import {ObservabService} from '../services/observab.service';
import {EventEmitteService} from '../services/eventEmitte.service';

@Component({
  selector: 'app-navigator',
  templateUrl: './navigator.component.html',
  styleUrls: ['./navigator.component.css']
})
export class NavigatorComponent implements OnInit {
  chechInfo: string = 'aa';
  constructor(private observBale: ObservabService, private eventEmitt: EventEmitteService) { }

  ngOnInit() {
    // this.observBale.obtainedCheckInfomation.subscribe( resp=>{
    //   this.chechInfo = resp;
    // });
    this.eventEmitt.changeDetailEvent.subscribe(resp => {
      if (resp === 'clear') {
        this.chechInfo = 'clear';
      }
    });
  }

  checkWhichPage(str: string) {
    if (this.chechInfo = 'aa') {
      this.chechInfo = 'bb';
    } else {
      this.chechInfo = 'aa';
    }

    //if (this.chechInfo !== 'default'){
    this.observBale.sendPageREFAinfo(str);
    //this.eventEmitt.changeDetailEvent.emit(str);
      console.log(str);

    }

 // }

}
